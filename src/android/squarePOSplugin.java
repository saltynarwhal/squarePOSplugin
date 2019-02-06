package com.saltynarwhal.cordova.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaInterfaceImpl;
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
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.app.Dialog;
import android.app.Activity;

import com.squareup.sdk.pos.ChargeRequest;
import com.squareup.sdk.pos.CurrencyCode;
import com.squareup.sdk.pos.PosClient;
import com.squareup.sdk.pos.PosSdk;

/*class AlertDialogHelper extends DialogFragment {

      private static AlertDialog mAlertDialog;

      @Override
      public Dialog onCreateDialog(Bundle savedInstanceState) {
        super.onCreateDialog(savedInstanceState);
        return null;
      }

      private static Dialog getDialog(Activity activity,
        String title, String description, int resourceId) {
        if (mAlertDialog == null) {
          mAlertDialog =  new AlertDialog.Builder(activity, resourceId)
              .setTitle(title + ": " + description)
              .setPositiveButton("OK", null)
              .create();
        } else {
          mAlertDialog.setTitle(title + ":" + description);
          mAlertDialog.setOwnerActivity(activity);
        }
        return mAlertDialog;
      }

      public static void showDialog(Activity activity, String title,
         String description) {
           int resourceId = 0;
           try {
             resourceId =
             activity
                  .getPackageManager()
                  .getActivityInfo(activity.getComponentName()
                      , 0)
                  .getThemeResource();
          } catch (PackageManager.NameNotFoundException e) {
          e.printStackTrace();
          } finally {
            getDialog(
              activity,
              title,
              description,
              resourceId).show();
            }
      }
}
*/
public class squarePOSplugin extends CordovaPlugin {
  private static final String APPLICATION_ID = "sq0idp-LtAn6a920ToNj7R4TcKrFA";
  private static final String TAG = "squarePOSplugin";

  //initialize callback to use in onActivityResult
  public CallbackContext callbackContext;
  private PosClient posClient;

  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    Log.d(TAG, "Initializing squarePOSplugin");


    posClient = PosSdk.createClient(cordova.getActivity(), APPLICATION_ID);
  }

  public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
    this.callbackContext = callbackContext;

    if(action.equals("startTransaction")){
      startTransaction(args, callbackContext);

      PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
      r.setKeepCallback(true);
      callbackContext.sendPluginResult(r);

      return true;
    } else {
      callbackContext.error("\"" + action + "\" is not a recognized action.");
      return false;
    }
  }

  // create a new charge request and initiate a Point of Sale transaction
  private static final int CHARGE_REQUEST_CODE = 1;
  public void startTransaction(JSONArray args, CallbackContext callbackContext) throws JSONException {
    //get jobid and amount
    JSONObject options = args.getJSONObject(0);
    String jobId = options.getString("jobid");
    int amount = options.getInt("amount");
    String customerId = options.getString("customerid");

    //build intent and execute app switch if Square POS is on the device
    ChargeRequest request = new ChargeRequest.Builder(
    amount,
    CurrencyCode.USD)
    .note(jobId)
    .requestMetadata(jobId)
    .build();
    try {
      Intent intent = posClient.createChargeIntent(request);

      PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
      r.setKeepCallback(true);
      callbackContext.sendPluginResult(r);

      cordova.setActivityResultCallback(this);
      cordova.startActivityForResult(this, intent, CHARGE_REQUEST_CODE);
    }
    catch (ActivityNotFoundException e) {

      this.callbackContext.error("Square Point of Sale is not installed");

      posClient.openPointOfSalePlayStoreListing();
    }
  }

  public Bundle onSaveInstanceState() {
    Bundle state = new Bundle();
    return state;
  }

  public void onRestoreStateForActivityResult(Bundle state, CallbackContext callbackContext) {
  }

  @Override public void onActivityResult(int requestCode, int resultCode, Intent data) {
    // Handle unexpected errors
    if (data == null || requestCode != CHARGE_REQUEST_CODE) {

      return;
    }

    // Handle expected results
    if (resultCode == Activity.RESULT_OK) {
      // Handle success
      ChargeRequest.Success success = posClient.parseChargeSuccess(data);

      //create JSONObject to pass back to outsystems Application
      /*JSONObject resultObj = new JSONObject();

      resultObj.put("clientTransactionId", success.clientTransactionId);
      resultObj.put("requestMetadata", success.requestMetadata);
      resultObj.put("serverTransactionId", success.serverTransactionId);*/

      //String test = success.clientTransactionId;

      this.callbackContext.success(success.serverTransactionId);

    } else {
      // Handle expected errors
      ChargeRequest.Error error = posClient.parseChargeError(data);

      this.callbackContext.error(error.debugDescription);
    }
    return;
  }
}
