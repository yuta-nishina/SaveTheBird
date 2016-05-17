package com.latte_project.stb.savethebird;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.Window;
import android.media.MediaPlayer;

public class MainActivity extends Activity {

    private MediaPlayer player;

    @Override
    // 初期表示
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // タイトル消し
        requestWindowFeature(Window.FEATURE_NO_TITLE);

        setContentView(R.layout.activity_main);

        // 再生中なら停止
        if (player != null && player.isPlaying()) {
            player.stop(); // 停止
            player.release();// メモリの解放
        }
        // 再生
        try {
            player = MediaPlayer.create(this, R.raw.sample);
            player.setLooping(true);  // 連続再生設定
            player.start(); // 再生

        } catch (IllegalArgumentException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
        }

        Handler handler = new Handler();
        handler.postDelayed(new splashHandler(), 2000);
    }

    // 自動画面遷移
    class splashHandler implements Runnable {
        public void run() {
            Intent inte = new Intent(getApplication(), HomeActivity.class);
            startActivity(inte);
            MainActivity.this.finish();
        }
    }
}
