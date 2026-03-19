import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../providers/location_provider.dart';
import '../providers/monster_provider.dart';
import '../models/monster_model.dart';
import '../widgets/battle_overlay.dart';

class GameMapView extends ConsumerStatefulWidget {
  const GameMapView({super.key});

  @override
  ConsumerState<GameMapView> createState() => _GameMapViewState();
}

class _GameMapViewState extends ConsumerState<GameMapView> {
// Custom markers for monsters
  final Map<String, BitmapDescriptor> _monsterIcons = {};

  @override
  void initState() {
    super.initState();
    _loadIcons();
    
    // Refresh monsters immediately as we now have location from HomeScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(monstersProvider.notifier).refreshMonsters();
    });
  }

  Future<void> _loadIcons() async {
    // In a real app, you would load custom icons from assets
    // For now, we use default markers with different colors as placeholders
    // or try to load the actual assets if they exist.
    try {
      _monsterIcons['recycleBeast'] = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/game/recycle_beast.png',
      );
      _monsterIcons['carbonCreature'] = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/game/carbon_creature.png',
      );
      _monsterIcons['ecoGuardian'] = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/game/eco_guardian.png',
      );
      if (mounted) setState(() {});
    } catch (e) {
      log('Error loading monster icons: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    // Controller can be used for other purposes, but we don't trigger 
    // a new location fetch here to avoid parent rebuild loop.
  }

  Set<Marker> _buildMarkers(List<MonsterModel> monsters, LocationData userLocation) {
    final Set<Marker> markers = {};

    for (final monster in monsters) {
      // Calculate distance
      final double distance = Geolocator.distanceBetween(
        userLocation.lat,
        userLocation.lng,
        monster.latitude,
        monster.longitude,
      );

      final bool canAttack = distance <= 500; // 50 meters range

      markers.add(
        Marker(
          markerId: MarkerId(monster.id),
          position: LatLng(monster.latitude, monster.longitude),
          icon: _monsterIcons[monster.type.name] ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: monster.name,
            snippet: '距離: ${distance.toStringAsFixed(1)}m ${canAttack ? "(可攻擊!)" : ""}',
          ),
          onTap: () {
            if (canAttack) {
              _startBattle(monster);
            } else {
              _showTooFarMessage(monster, distance);
            }
          },
        ),
      );
    }

    return markers;
  }

  void _startBattle(MonsterModel monster) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BattleOverlay(monster: monster),
    );
  }

  void _showTooFarMessage(MonsterModel monster, double distance) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('太遠了！距離 ${monster.name} 還有 ${distance.toStringAsFixed(0)}m'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = ref.watch(userLocationProvider);
    final monsters = ref.watch(monstersProvider);
    final userLocation = locationState.location;

    // We don't need redundant animateCamera here since initialCameraPosition
    // is now set correctly after GameHomeScreen's loading state finishes.

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(userLocation.lat, userLocation.lng),
        zoom: 16,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _buildMarkers(monsters, userLocation),
      style: isDark ? _mapDarkStyle : null, // Dynamic style
    );
  }

  // Dark mode style for Google Maps
  static const String _mapDarkStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  }
]
''';
}
