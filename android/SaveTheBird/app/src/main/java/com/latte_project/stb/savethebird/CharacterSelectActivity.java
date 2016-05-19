package com.latte_project.stb.savethebird;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


public class CharacterSelectActivity extends TabActivity {

    ViewPagerIndicator mViewPagerIndicator;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_character_select);

        ViewPager mViewPager = (ViewPager)findViewById(R.id.viewpager);
        CustomPagerAdapter mPagerAdapter = new CustomPagerAdapter(this);
        mViewPager.setAdapter(mPagerAdapter);


        mViewPagerIndicator = (ViewPagerIndicator) findViewById(R.id.indicator);
        mViewPagerIndicator.setCount(mPagerAdapter.getCount());
        mViewPager
                .setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() {
                    @Override
                    public void onPageSelected(int position) {
                        super.onPageSelected(position);
                        mViewPagerIndicator.setCurrentPosition(position);
                    }
                });

    }

    private class CustomPagerAdapter extends PagerAdapter {

        int[] pages = {R.layout.char1, R.layout.char2, R.layout.char3};

        Context mContext;

        public CustomPagerAdapter(Context context) {
            mContext = context;
        }

        @Override
        public int getCount() {
            return pages.length;
        }

        @Override
        public boolean isViewFromObject(View v, Object o) {
            return v.equals(o);
        }

        @Override
        public Object instantiateItem(ViewGroup container, int position) {

            LayoutInflater inflater = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);

            View layout ;
            layout = inflater.inflate(pages[position], null);
            ((ViewPager) container).addView(layout);
            return layout;

        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            ((ViewPager)container).removeView((View)object);
        }
    }



}
