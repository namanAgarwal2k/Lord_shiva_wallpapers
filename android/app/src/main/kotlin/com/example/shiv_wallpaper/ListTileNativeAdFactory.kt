

package com.codelab.flutter.admobinlineads

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.google.android.gms.ads.nativead.MediaView
import com.sudoStudio.shiv_wallpaper.R
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class ListTileNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.list_tile_native_ad, null) as NativeAdView

        with(nativeAdView) {
            val attributionViewSmall =
                findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_small)
//            val attributionViewLarge =
//                findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_large)

            val iconView = findViewById<ImageView>(R.id.native_ad_icon)
            val icon = nativeAd.icon
            if (icon != null) {
                attributionViewSmall.visibility = View.VISIBLE
//                attributionViewLarge.visibility = View.INVISIBLE
                iconView.setImageDrawable(icon.drawable)
            } else {
                attributionViewSmall.visibility = View.INVISIBLE
//                attributionViewLarge.visibility = View.VISIBLE
            }
            this.iconView = iconView

            val mediaView=findViewById<MediaView>(R.id.native_ad_media)
            mediaView.mediaContent=nativeAd.mediaContent
            nativeAdView.mediaView = mediaView

            nativeAdView.callToActionView = nativeAdView.findViewById<Button>(R.id.native_ad_button)
            if (nativeAd.callToAction == null) {
                nativeAdView.callToActionView!!.visibility = View.INVISIBLE
            } else {
                (nativeAdView.callToActionView as Button?)!!.text = nativeAd.callToAction
            }
            val headlineView = findViewById<TextView>(R.id.native_ad_headline)
            headlineView.text = nativeAd.headline
            this.headlineView = headlineView

            val bodyView = findViewById<TextView>(R.id.native_ad_body)
            with(bodyView) {
                text = nativeAd.body
                visibility = if (nativeAd.body?.isNotEmpty() == true) View.VISIBLE else View.INVISIBLE
            }
            this.bodyView = bodyView

            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}
