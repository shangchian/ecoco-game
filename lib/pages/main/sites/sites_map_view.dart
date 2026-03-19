import '../../../constants/colors.dart';
import '/models/site_model.dart';
import '/pages/main/sites/site_card.dart';
import '/providers/location_provider.dart';
import '/providers/sorted_sites_provider.dart';
import '/providers/site_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/l10n/app_localizations.dart';
import '/utils/error_messages.dart';

class SitesMapView extends ConsumerStatefulWidget {
  final Function(bool) onLoadingChanged;
  const SitesMapView({super.key, required this.onLoadingChanged});

  @override
  ConsumerState<SitesMapView> createState() => _SitesMapViewState();
}

class _SitesMapViewState extends ConsumerState<SitesMapView> {
  GoogleMapController? _mapController;
  bool _isFirstLoad = true;
  Site? _selectedSite;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Site> _searchResults = [];

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Set<Marker> _createMarkers(List<Site> sites) {
    return sites.map((site) {
      return Marker(
        markerId: MarkerId(site.id),
        position: LatLng(site.latitudeAsDouble, site.longitudeAsDouble),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          site.isOpen ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
        onTap: () {
          setState(() {
            _selectedSite = site;
          });
        },
      );
    }).toSet();
  }

  void _moveToUserLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15,
        ),
      ),
    );
  }

  void _performSearch(String query, List<Site> sites) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _searchResults = sites
          .where((site) =>
              site.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(userLocationProvider);
    final userLocation = locationState.location;
    final sortedSitesAsync = ref.watch(sortedSitesProvider);
    final appLocale = AppLocalizations.of(context);

    return sortedSitesAsync.when(
      data: (sortedSites) {
        if (_selectedSite != null) {
          final updatedSite = sortedSites.firstWhere(
            (site) => site.id == _selectedSite!.id,
            orElse: () => _selectedSite!,
          );
          if (updatedSite != _selectedSite) {
            _selectedSite = updatedSite;
          }
        }

        return _buildMapView(context, sortedSites, userLocation, appLocale);
      },
      loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          )
      ),
      error: (error, stack) => Center(child: Text('Error: ${ErrorMessages.getDisplayMessage(error.toString())}')),
    );
  }

  Widget _buildMapView(BuildContext context, List<Site> sortedSites, LocationData userLocation, AppLocalizations? appLocale) {
    return Stack(
      children: [
        RepaintBoundary(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(userLocation.lat, userLocation.lng),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _createMarkers(sortedSites),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              if (_isFirstLoad) {
                _moveToUserLocation(LatLng(userLocation.lat, userLocation.lng));
                _isFirstLoad = false;
              }
            },
            onTap: (_) {
              setState(() {
                _selectedSite = null;
              });
            },
          ),
        ),
        if (_selectedSite == null && !_isSearching)
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              _moveToUserLocation(LatLng(userLocation.lat, userLocation.lng));
            },
            child: Icon(Icons.my_location, color: Colors.grey[600]!),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          _isSearching ? Icons.close : Icons.arrow_back,
                          color: Colors.black54,
                          size: 18,
                        ),
                        onPressed: () {
                          if (_isSearching) {
                            setState(() {
                              _searchController.clear();
                              _searchResults = [];
                              _isSearching = false;
                            });
                            FocusScope.of(context).unfocus();
                          } else {
                            //Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.0,
                        ),
                        decoration: const InputDecoration(
                          hintText: '搜尋站點名稱',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            height: 1.0,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onTap: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                        onChanged: (value) {
                          _performSearch(value, sortedSites);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isSearching)
          Positioned(
            top: 80,
            left: 16,
            right: 16,
            bottom: 0,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final site = _searchResults[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(site.name),
                    subtitle: Text(site.address),
                    trailing:
                        Text('${site.distance?.toStringAsFixed(1)} km'),
                    onTap: () {
                      setState(() {
                        _selectedSite = site;
                        _searchResults = [];
                        _isSearching = false;
                        _searchController.clear();
                      });

                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(
                              site.latitudeAsDouble,
                              site.longitudeAsDouble,
                            ),
                            zoom: 15,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        if (_selectedSite != null && !_isSearching)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SiteCard(
                title: _selectedSite!.name,
                address: _selectedSite!.address,
                serviceHours: _selectedSite!.serviceHours,
                status: _selectedSite!.isOpen
                    ? SiteStatus.open
                    : SiteStatus.closed,
                latitude: _selectedSite!.latitudeAsDouble,
                longitude: _selectedSite!.longitudeAsDouble,
                distance: _selectedSite!.distance,
                recyclableItems: _selectedSite!.recyclableItems,
                siteType: _selectedSite!.type,
                isFavorite: _selectedSite?.favorite ?? false,
                onFavoriteToggle: () async {
                  if (_selectedSite == null) {
                    return;
                  }
                  widget.onLoadingChanged(true);
                  final siteNotifier = ref.read(sitesProvider.notifier);
                  try {
                    await siteNotifier.toggleFavorite(
                      _selectedSite!.code,
                      !_selectedSite!.favorite,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => SimpleErrorAlert(
                          message: e.toString(),
                          buttonText: appLocale?.okay ?? '',
                          onPressed: () {},
                        ),
                      );
                    }
                  } finally {
                    widget.onLoadingChanged(false);
                  }
                },
              ),
            ),
          ),
      ],
    );
  }
}
