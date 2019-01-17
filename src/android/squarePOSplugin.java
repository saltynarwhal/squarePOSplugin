package com.saltynarwhal.cordova.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.content.ActivityNotFoundException;

import com.squareup.sdk.pos.ChargeRequest;
import com.squareup.sdk.pos.CurrencyCode;
import com.squareup.sdk.pos.PosClient;
import com.squareup.sdk.pos.PosSdk;

public class squarePOSplugin extends CordovaPlugin {
  private static final String APPLICATION_ID = "sq0idp-qHqpaVYtEOSxH1Kz6IODFw";
  private static final String TAG = "squarePOSplugin";

  private PosClient posClient;

  /*protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main_activity);
    // Replace APPLICATION_ID with a Square-assigned application ID
    posClient = PosSdk.createClient(this, APPLICATION_ID);
  }*/

  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    Log.d(TAG, "Initializing squarePOSplugin");

    posClient = PosSdk.createClient(cordova.getActivity(), APPLICATION_ID);
  }

  public boolean execute(String action, final CallbackContext callbackContext) {

    if(action.equals("startTransaction")){
      startTransaction();

      return true;
    } else {
      callbackContext.error("\"" + action + "\" is not a recognized action.");
      return false;
    }
  }

  // create a new charge request and initiate a Point of Sale transaction
  private static final int CHARGE_REQUEST_CODE = 1;
  public void startTransaction() {
    ChargeRequest request = new ChargeRequest.Builder(
    100,
    CurrencyCode.USD)
    .build();
    try {
      Intent intent = posClient.createChargeIntent(request);

      cordova.setActivityResultCallback (this);
      cordova.startActivityForResult(this, intent, CHARGE_REQUEST_CODE);
    }
    catch (ActivityNotFoundException e) {
      AlertDialogHelper.showDialog(
        this,
        "Error",
        "Square Point of Sale is not installed"
      );
      posClient.openPointOfSalePlayStoreListing();
    }
  }

  @Override public void onActivityResult(int requestCode, int resultCode, Intent data) {

    // Handle unexpected errors
    if (data == null || requestCode != CHARGE_REQUEST_CODE) {
      AlertDialogHelper.showDialog(this, "Error: unknown", "Square Point of Sale was uninstalled or stopped working");
      return;
    }

    // Handle expected results
    if (resultCode == Activity.RESULT_OK) {
      // Handle success
      ChargeRequest.Success success = posClient.parseChargeSuccess(data);
      AlertDialogHelper.showDialog(this,
        "Success",
        "Client transaction ID: "
            + success.clientTransactionId);
    } else {
      // Handle expected errors
      ChargeRequest.Error error = posClient.parseChargeError(data);
      AlertDialogHelper.showDialog(this,
          "Error" + error.code,
          "Client transaction ID: "
              + error.debugDescription);
    }
    return;
  }
}
