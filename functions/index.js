const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Health Check Function
 * Used to verify Cloud Functions are working correctly.
 */
exports.healthCheck = functions.https.onCall((data, context) => {
  return {
    status: "ok",
    timestamp: new Date().toISOString(),
    message: "ECOCO Game Functions are online."
  };
});

/**
 * Exchange AccessToken for Firebase Custom Token
 * This bridges the existing phone/password auth with Firebase.
 */
exports.exchangeToken = functions.https.onCall(async (data, context) => {
  const accessToken = data.accessToken;
  
  if (!accessToken) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing access token');
  }

  try {
    // TODO: Verify accessToken against your existing backend API
    // const userData = await verifyWithMainBackend(accessToken);
    
    // For now, we'll use a placeholder UID (In production, use the member ID from your DB)
    const uid = "MOCK_USER_ID"; // Replace with real member ID after validation
    
    const customToken = await admin.auth().createCustomToken(uid);
    return { customToken };
  } catch (error) {
    log("Error creating custom token:", error);
    throw new functions.https.HttpsError('internal', 'Failed to create custom token');
  }
});

/**
 * Placeholder for Monster Spawn Logic (Phase 2)
 * This will be triggered by a scheduled function or admin action.
 */
// exports.spawnMonsters = functions.pubsub.schedule('every 1 hours').onRun((context) => {
//   // TODO: Implement monster spawning logic based on game_schema.md
//   return null;
// });
