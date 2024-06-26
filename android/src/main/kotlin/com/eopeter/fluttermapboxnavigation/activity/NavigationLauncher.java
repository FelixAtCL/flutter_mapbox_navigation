package com.eopeter.fluttermapboxnavigation.activity;

import android.app.Activity;
import android.content.Intent;

import com.eopeter.fluttermapboxnavigation.models.Waypoint;

import java.io.Serializable;
import java.util.List;

public class NavigationLauncher {
    public static final String KEY_ADD_WAYPOINTS = "com.my.mapbox.broadcast.ADD_WAYPOINTS";
    public static final String KEY_ADD_WAYPOINT_AT = "com.my.mapbox.broadcast.ADD_WAYPOINT_AT";
    public static final String KEY_UPDATE_WAYPOINTS = "com.my.mapbox.broadcast.UPDATE_WAYPOINTS";
    public static final String KEY_STOP_NAVIGATION = "com.my.mapbox.broadcast.STOP_NAVIGATION";
    public static void startNavigation(Activity activity, List<Waypoint> wayPoints) {
        Intent navigationIntent = new Intent(activity, NavigationActivity.class);
        navigationIntent.putExtra("waypoints", (Serializable) wayPoints);
        activity.startActivity(navigationIntent);
    }

    public static void addWayPoints(Activity activity, List<Waypoint> wayPoints) {
        Intent navigationIntent = new Intent(activity, NavigationActivity.class);
        navigationIntent.setAction(KEY_ADD_WAYPOINTS);
        navigationIntent.putExtra("isAddingWayPoints", true);
        navigationIntent.putExtra("waypoints", (Serializable) wayPoints);
        activity.sendBroadcast(navigationIntent);
    }

    public static void addWayPointAt(Activity activity, Waypoint wayPoint, int position) {
        Intent navigationIntent = new Intent(activity, NavigationActivity.class);
        navigationIntent.setAction(KEY_ADD_WAYPOINT_AT);
        navigationIntent.putExtra("isAddingWayPoints", true);
        navigationIntent.putExtra("waypoint", wayPoint);
        navigationIntent.putExtra("position", position);
        activity.sendBroadcast(navigationIntent);
    }

    public static void updateWayPoints(Activity activity, List<Waypoint> wayPoints) {
        Intent navigationIntent = new Intent(activity, NavigationActivity.class);
        navigationIntent.setAction(KEY_UPDATE_WAYPOINTS);
        navigationIntent.putExtra("isUpdatingWayPoints", true);
        navigationIntent.putExtra("waypoints", (Serializable) wayPoints);
        activity.sendBroadcast(navigationIntent);
    }

    public static void stopNavigation(Activity activity) {
        Intent stopIntent = new Intent();
        stopIntent.setAction(KEY_STOP_NAVIGATION);
        activity.sendBroadcast(stopIntent);
    }
}
