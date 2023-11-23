package com.codelab.flutter.admobinlineads

import com.sudoStudio.shiv_wallpaper.R
import android.content.Context
import android.graphics.text.TextRunShaper
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


 class NativeAdFactoryMedium(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory
 {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val nativeAdView = LayoutInflater.from(
            context
        )
            .inflate(R.layout.medium_template, null) as NativeAdView


//    attribution
        val attributionViewSmall = nativeAdView
            .findViewById<TextView>(R.id.native_ad_attribution_small)
        attributionViewSmall.visibility = View.VISIBLE
        // icon
        nativeAdView.iconView = nativeAdView.findViewById<ImageView>(R.id.native_ad_icon)
        if (nativeAd.icon == null) {
            nativeAdView.iconView!!.visibility = View.GONE
        } else {
            (nativeAdView.iconView as ImageView?)!!.setImageDrawable(
                nativeAd.icon!!.drawable
            )
        }

//  media
        val mediaView = nativeAdView.findViewById<MediaView>(R.id.native_ad_media)
        mediaView.mediaContent = nativeAd.mediaContent
        nativeAdView.mediaView = mediaView

// button
        nativeAdView.callToActionView = nativeAdView.findViewById<Button>(R.id.native_ad_button)
        if (nativeAd.callToAction == null) {
            nativeAdView.callToActionView!!.visibility = View.INVISIBLE
        } else {
            (nativeAdView.callToActionView as Button?)!!.text = nativeAd.callToAction
        }

//   headline
        nativeAdView.headlineView = nativeAdView.findViewById<TextView>(R.id.native_ad_headline)
        (nativeAdView.headlineView as TextView?)!!.text = nativeAd.headline

//  bodyView
        nativeAdView.bodyView = nativeAdView.findViewById<TextView>(R.id.native_ad_body)
        if (nativeAd.body == null) {
            nativeAdView.bodyView!!.visibility = View.INVISIBLE
        } else {
            (nativeAdView.bodyView as TextView?)!!.text = nativeAd.body
            nativeAdView.bodyView!!.visibility = View.VISIBLE
        }

//    advertiser name
        nativeAdView.advertiserView = nativeAdView.findViewById<TextView>(R.id.native_ad_advertiser)
        if (nativeAd.advertiser == null) {
            nativeAdView.advertiserView!!.visibility = View.GONE
        } else {
            (nativeAdView.advertiserView as TextView?)!!.text = nativeAd.advertiser
            nativeAdView.advertiserView!!.visibility = View.VISIBLE
        }
        //   ratingbar
        nativeAdView.starRatingView = nativeAdView.findViewById<RatingBar>(R.id.native_ad_rating)
        if (nativeAd.starRating == null) {
            nativeAdView.starRatingView!!.visibility = View.INVISIBLE
        } else {
            (nativeAdView.starRatingView as RatingBar?)!!.rating = nativeAd.starRating!!.toFloat()
            nativeAdView.starRatingView!!.visibility = View.VISIBLE
        }
        nativeAdView.setNativeAd(nativeAd)
        return nativeAdView
    }
}