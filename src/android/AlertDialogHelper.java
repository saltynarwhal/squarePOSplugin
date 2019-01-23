package com.saltynarwhal.cordova.plugin;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;

public class AlertDialogHelper extends DialogFragment {

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
