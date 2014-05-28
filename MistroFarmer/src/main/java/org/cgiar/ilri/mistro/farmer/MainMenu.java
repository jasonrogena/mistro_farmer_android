package org.cgiar.ilri.mistro.farmer;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.actionbarsherlock.app.SherlockActivity;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import org.cgiar.ilri.mistro.farmer.backend.DataHandler;
import org.cgiar.ilri.mistro.farmer.backend.Locale;
import org.json.JSONException;
import org.json.JSONObject;

public class MainMenu extends SherlockActivity implements MistroActivity, View.OnClickListener, LocationListener
{
    private static final String TAG="MainMenu";
    public static final String KEY_LONGITUDE = "longitude";
    public static final String KEY_LATITUDE = "latitude";
    public static final String KEY_FARMER_DATA = "farmerData";
    private Button milkProductionB;
    private Button fertilityB;
    private Button eventsB;
    private Button logoutB;
    private JSONObject farmerData;
    private LocationManager locationManager;
    private String longitude;
    private String latitude;
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);
        //DataHandler.requestPermissionToUseSMS(this);

        milkProductionB=(Button)this.findViewById(R.id.milk_production_b);
        milkProductionB.setOnClickListener(this);
        fertilityB = (Button)this.findViewById(R.id.fertility_b);
        fertilityB.setOnClickListener(this);
        eventsB =(Button)this.findViewById(R.id.events_b);
        eventsB.setOnClickListener(this);
        logoutB = (Button)this.findViewById(R.id.logout_b);
        logoutB.setOnClickListener(this);

        Bundle bundle=this.getIntent().getExtras();
        if(bundle != null){
            String farmerJSONString = bundle.getString(KEY_FARMER_DATA);

            try{
                farmerData = new JSONObject(farmerJSONString);
                registerCoords();

                Toast.makeText(this, Locale.getStringInLocale("welcome", this)+" "+farmerData.getString("name"), Toast.LENGTH_LONG).show();
            }
            catch (Exception e){
                e.printStackTrace();
            }
        }

        initTextInViews();
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getSupportMenuInflater();
        inflater.inflate(R.menu.main_menu, menu);
        return true;
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        if(Language.processLanguageMenuItemSelected(this, this, item)){
            return true;
        }
        return false;
    }

    @Override
    public void initTextInViews()
    {
        this.setTitle(Locale.getStringInLocale("main_menu",this));
        milkProductionB.setText(Locale.getStringInLocale("milk_production", this));
        fertilityB.setText(Locale.getStringInLocale("fertility",this));
        eventsB.setText(Locale.getStringInLocale("events",this));
        logoutB.setText(Locale.getStringInLocale("logout", this));
    }

    @Override
    public void onClick(View view) {
        sendDataToServer();
        if(view==milkProductionB)
        {
            Intent intent=new Intent(this,MilkProductionActivity.class);
            startActivity(intent);
        }
        else if(view == fertilityB){
            Intent intent=new Intent(this,FertilityActivity.class);
            startActivity(intent);
        }
        else if(view==eventsB)
        {
            Intent intent=new Intent(this,EventsActivity.class);
            startActivity(intent);
        }
        else if(view==logoutB){
            Intent intent = new Intent(this, LandingActivity.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            startActivity(intent);
        }
    }

    private void registerCoords(){
        try {
            String regLongitude = farmerData.getString("gps_longitude");
            String regLatitude = farmerData.getString("gps_latitude");
            if(regLongitude==null || regLongitude.trim().length()==0 || regLatitude==null || regLatitude.trim().length()==0){
                buildGPSAlert();
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void buildGPSAlert(){
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(Locale.getStringInLocale("are_you_in_farm",this));
        builder.setPositiveButton(Locale.getStringInLocale("yes",this), new DialogInterface.OnClickListener(){

            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                getGPSCoordinates();
            }
        });
        builder.setNegativeButton(Locale.getStringInLocale("no",this), new DialogInterface.OnClickListener(){
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
            }
        });

        AlertDialog alertDialog = builder.create();
        alertDialog.show();
    }

    private void getGPSCoordinates() {
        locationManager=(LocationManager)getSystemService(LOCATION_SERVICE);
        if(locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER))
        {
            //Toast.makeText(this,"gps started",Toast.LENGTH_LONG).show();
            Criteria criteria=new Criteria();
            String provider=locationManager.getBestProvider(criteria,false);
            Location location=locationManager.getLastKnownLocation(provider);
            locationManager.requestLocationUpdates(provider,18000,1000,this);//If farmer  is moving at 200km/h, will still be able to update!
            if(location!=null)
            {
                onLocationChanged(location);
            }
        }
        else
        {
            AlertDialog.Builder alertDialogBuilder=new AlertDialog.Builder(this);
            alertDialogBuilder.setTitle(Locale.getStringInLocale("enable_gps",this));
            alertDialogBuilder
                    .setMessage(Locale.getStringInLocale("reason_for_enabling_gps", this))
                    .setCancelable(false)
                    .setPositiveButton(Locale.getStringInLocale("okay",this), new DialogInterface.OnClickListener()
                    {
                        @Override
                        public void onClick(DialogInterface dialog, int which)
                        {
                            Intent intent=new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                            startActivity(intent);
                        }
                    })
                    .setNegativeButton(Locale.getStringInLocale("cancel",this), new DialogInterface.OnClickListener()
                    {
                        @Override
                        public void onClick(DialogInterface dialog, int which)
                        {
                            dialog.cancel();
                            Intent intent=new Intent(MainMenu.this,LandingActivity.class);
                            startActivity(intent);
                        }
                    });
            AlertDialog alertDialog=alertDialogBuilder.create();
            alertDialog.show();

        }
    }

    @Override
    public void onLocationChanged(Location location) {
        latitude=String.valueOf(location.getLatitude());
        longitude=String.valueOf(location.getLongitude());
        Log.d(TAG,"latitude : "+latitude);
        Log.d(TAG,"longitude : "+longitude);
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }

    private void sendDataToServer(){
        if(longitude!=null && longitude.trim().length()>0 && latitude!=null && latitude.trim().length()>0){
            JSONObject jsonObject = new JSONObject();
            try {
                TelephonyManager telephonyManager=(TelephonyManager)this.getSystemService(Context.TELEPHONY_SERVICE);
                jsonObject.put("simCardSN",telephonyManager.getSimSerialNumber());
                jsonObject.put("longitude",longitude);
                jsonObject.put("latitude",latitude);
                CoordinateHandler coordinateHandler = new CoordinateHandler();
                coordinateHandler.execute(jsonObject);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    private class CoordinateHandler extends AsyncTask<JSONObject, Integer, String>{
        @Override
        protected String doInBackground(JSONObject... params) {
            return DataHandler.sendDataToServer(MainMenu.this, params[0].toString(),DataHandler.FARMER_REGISTER_FARM_COORDS_URL, false);
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

            if(result!=null && result.equals(DataHandler.ACKNOWLEDGE_OK)){
                Toast.makeText(MainMenu.this,Locale.getStringInLocale("farm_coords_successfully_reg", MainMenu.this),Toast.LENGTH_LONG).show();
            }
        }
    }
}
