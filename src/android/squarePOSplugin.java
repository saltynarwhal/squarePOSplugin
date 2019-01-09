import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;
import android.content.Context;
import android.content.Intent;

public class squarePOSplugin extends CordovaPlugin {
  private static final String APPLICATION_ID = "sq0idp-qHqpaVYtEOSxH1Kz6IODFw";

  private PosClient posClient;

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main_activity);
    // Replace APPLICATION_ID with a Square-assigned application ID
    posClient = PosSdk.createClient(this, APPLICATION_ID);
  }

  public boolean execute(String action, final CallbackContext callbackContext) {

    if(action.equals("startTransaction")){
      startTransaction();
      return true;
    } else if (action.equals("onActivityResult")) {
      onActivityResult();
      return true;
    } else {
      callbackContext.error("\"" + action + "\" is not a recognized action.");
      return false;
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
      startActivityForResult(intent, CHARGE_REQUEST_CODE);
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

  @Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {

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
