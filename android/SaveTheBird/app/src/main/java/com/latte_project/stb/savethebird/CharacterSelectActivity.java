package com.latte_project.stb.savethebird;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;


public class CharacterSelectActivity extends TabActivity {

    ViewPagerIndicator mViewPagerIndicator;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_character_select);

        // スワイプボックス
        ViewPager mViewPager = (ViewPager)findViewById(R.id.viewpager);
        CustomPagerAdapter mPagerAdapter = new CustomPagerAdapter(this);
        mViewPager.setAdapter(mPagerAdapter);

        // フォント変更
        TextView txtCName = (TextView) findViewById(R.id.charctorName);
        setFontType(txtCName);

        // フォント変更
        TextView txtCDetail = (TextView) findViewById(R.id.charactorDetail);
        setFontType(txtCDetail);


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

    /**
     *  カスタムアダプター
     */
    private class CustomPagerAdapter extends PagerAdapter {

        int[] pages = {R.layout.char1, R.layout.char2, R.layout.char3};
        Context mContext;

        public CustomPagerAdapter(Context context) {
            mContext = context;
        }

        // ページ数
        @Override
        public int getCount() {
            return pages.length;
        }

        @Override
        public boolean isViewFromObject(View v, Object o) {
            Log.i("test", "isViewFromObject");
            return v.equals(o);
        }

        // ページ切替
        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            Log.i("test", "instantiateItem");

            LayoutInflater inflater = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);

            View layout ;
            layout = inflater.inflate(pages[position], null);
            ((ViewPager) container).addView(layout);
            return layout;

        }

        // 削除
        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            Log.i("test", "destroy");
            ((ViewPager)container).removeView((View)object);
        }
    }



}
