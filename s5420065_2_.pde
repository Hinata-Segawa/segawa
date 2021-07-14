int clickCount = 0;
//一つのロード画面が実行された時間を格納する
int executionTime = 0;
boolean isBubbleSort = false;
boolean isBlueScreen = false;


abstract class Loading {
  abstract void display();
  abstract void update();
  //ロード画面にNow Loadingと表示する
  void catText() {
    textSize(32);
    fill(0);
    text("Now Loading", width/2-100, height-100);
  }
}

//円弧が回転するロード画面
class LoadArc extends Loading {
  int x;
  int y;
  int dir;
  //円弧の始点となるradian
  float startRad;
  //円弧の終点となるradian
  float endRad;
  //円弧の位置を更新するradian
  float deltaRadian = 0.05;
  color arcColor;
  //円弧の中心座標，直径，色を決める
  LoadArc(int x, int y, int dir, color arcColor) {
    this.x = x;
    this.y = y;
    this.dir = dir;
    startRad = random(0, TWO_PI);
    endRad = startRad + PI;
    this.arcColor = arcColor;
  }

  void display() {
    push();
    background(255);
    frameRate(60);
    stroke(arcColor);
    noFill();
    strokeWeight(20);
    arc(x, y, dir, dir, startRad, endRad);
    pop();
    catText();
  }
  //円弧の更新
  void update() {
    startRad += deltaRadian;
    endRad += deltaRadian;
  }
}

//大きな円周の上を回転していく円
class LoadSpin extends Loading {
  //大きな円周の色を管理する
  color largeCol;
  //小さな円の色を管理する
  color smallCol;
  int largeX, largeY;
  float smallX, smallY;
  float smallRad;
  float deltaRadian = 0.07;
  int largeDir;
  //円周上の円の背景となる円の直径
  int smallBackDir = 60;
  //円周上の円の直径
  int smallFlontDir = 40;
  //円周の中心座標，直径，色を指定
  LoadSpin(int x, int y, int dir, color circleCol) {
    largeX = x;
    largeY = y;
    largeDir = dir;
    //回転する円の初期位置をランダムで決める
    smallRad = random(0, TWO_PI);
    smallX = x + (dir/2)*cos(smallRad);
    smallY = y + (dir/2)*sin(smallRad);
    largeCol = circleCol;
    //円周上を回転する円は円周と同じ色にする
    smallCol = circleCol;
  }
  void display() {
    push();
    background(255);
    noFill();
    strokeWeight(10);
    stroke(largeCol);
    circle(largeX, largeY, largeDir);
    pop();

    push();
    noStroke();
    fill(255);
    circle(smallX, smallY, smallBackDir);
    fill(smallCol);
    circle(smallX, smallY, smallFlontDir);
    pop();
    catText();
  }
  //回転する円の座標を更新
  void update() {
    smallRad += deltaRadian;
    smallX = largeX + (largeDir/2)*cos(smallRad);
    smallY = largeY + (largeDir/2)*sin(smallRad);
  }
}

//複数の円が回転するロード画面
class LoadSpinCircles extends Loading {
  float[] circleX;
  float[] circleY;
  //円の回転軌道の原点
  //初期値はwindowの中心
  float orbitX = width/2;
  float orbitY = height/2;
  int circleDir;
  float orbitDir;
  color circleColor;
  float circleRadian;
  float deltaRadian = 0.6;
  //回転する円の個数，回転軌道の直径，円の直径，円の色を指定
  LoadSpinCircles(int n, float orbitDir, int dir, color circleColor) {
    circleX = new float[n];
    circleY = new float[n];
    this.orbitDir = orbitDir;
    circleDir = dir;
    this.circleColor = circleColor;
    //円の初期位置をランダムで決める
    circleRadian = random(0, TWO_PI);
    for (int i = 0; i < n; i++) {
      circleX[i] = (orbitDir/2)*cos(circleRadian) + orbitX;
      circleY[i] = (orbitDir/2)*sin(circleRadian) + orbitY;
    }
  }

  void display() {
    push();
    background(255);
    frameRate(10);
    noStroke();
    background(255);
    fill(circleColor);
    for (int i = 0; i < circleX.length; i++) {
      circle(circleX[i], circleY[i], circleDir);
    }
    pop();
    catText();
  }

  void update() {
    circleRadian += deltaRadian;

    circleX[0] = (orbitDir/2)*cos(circleRadian) + orbitX;
    circleY[0] = (orbitDir/2)*sin(circleRadian) + orbitY;
    //ひとつ前の円の座標を後ろにずらす
    for (int i = circleX.length-1; i > 0; i--) {
      circleX[i] = circleX[i-1];
      circleY[i] = circleY[i-1];
    }
  }
}

class ProgressBar extends Loading {
  int frameX;
  int frameY;
  float frameW;
  int frameH;
  //ゲージの座標
  int gageX;
  int gageY;
  float gageW;
  int gageH;
  int progressSpeed;
  //描画された回数をカウント
  int progressCnt = 0;
  color gageCol;
  //フレームの位置，大きさ，ゲージの色を指定
  ProgressBar(int x, int y, int w, int h, color gageCol) {
    frameW = w;
    frameH = h;
    gageH = h;
    frameX = x - w/2;
    frameY = y;
    gageX = x - w / 2;
    gageY = y;
    this.gageCol = gageCol;
    //ゲージのたまりやすさをランダムで決める
    progressSpeed = int(random(50, 100));
  }
  void display() {
    //ゲージの横幅を「描画された回数%ゲージのたまりやすさ」とし，map関数を用いて値の範囲を0から100とする
    gageW = map(progressCnt%(progressSpeed + 1), 0, progressSpeed, 0, frameW);
    //ゲージが100%になったらバブルソートのフラグを立てる
    if (progressCnt%(progressSpeed +1)== progressSpeed) {
      isBubbleSort = true;
    }
    push();
    background(255);
    stroke(0);
    strokeWeight(10);
    noFill();
    rect(frameX, frameY, frameW, frameH);
    fill(gageCol);

    rect(gageX, gageY, gageW, gageH);

    fill(gageCol);
    text("DOWNLOAD", width/2 - frameW /2 + 32, height/2-frameH/4);
    text(int((gageW/frameW)*100) + "%", width*3/4 - frameW/3, height/2 - frameH/4);
    pop();
  }
  //描画された回数を更新する
  void update() {
    progressCnt++;
  }
}

//昇順ソートを行うアニメーション
class BubbleSort {
  int[] data;
  final int dataWidth;
  int endIndex = 0;
  int buffer = 0;
  int now = 0;
  int startIndex = 0;

  BubbleSort(int n) {
    data = new int[n];

    dataWidth = width/(n);
    
    initData();
  }
  //ソートするデータをランダムに作成
  void initData() {
    for (int i = 0; i < data.length; i++) {
      data[i] = int(random(40, height));
    }
  }
  void display() {
    push();
    background(255);
    colorMode(HSB, 360, 100, 100);
    frameRate(40);
    background(360, 0, 0);
    strokeWeight(1);
    for (int i = 0; i < data.length; i++) {
      //入れ替わった値であれば色を変更する
      if (i == startIndex && data[i] == buffer) {
        fill(frameCount % 360, 100, 100);
      } else {
        fill(200, 100, 100);
      }
      rect(i*dataWidth, height - data[i], dataWidth, data[i]);
    }
    pop();
    update();
  }

  void update() {
    //操作しているデータが左端に行った時の更新処理
    if ((now + 1 == data.length - endIndex && endIndex <= data.length) || now >= data.length - 1) {
      endIndex++;
      now = 0;
      buffer = -1;
    } 
    //操作しているデータよりも次のデータが大きい場合入れ替える
    if (data[now] > data[now+1]) {
      buffer = data[now];
      data[now] = data[now+1];
      data[now+1] = buffer;
      startIndex = now + 1;
    } 
    //操作するデータの更新
    now++;
  }
}




LoadArc la;
LoadSpin lp;
LoadSpinCircles lsc;
ProgressBar pb;
BubbleSort bs;

void setup() {
  size(800, 800);
  la = new LoadArc(width/2, height/2, 400, color(0, 0, 255));
  lp = new LoadSpin(width/2, height/2, 400, color(0, 0, 255));
  lsc = new LoadSpinCircles(5, 200, 25, color(0, 0, 255));
  pb = new ProgressBar(width/2, height/2, 300, 100, color(0, 0, 255));
  bs = new BubbleSort(20);
}

void draw() {
  
  int now = clickCount % 4;
  if (isBubbleSort) {
    bs.display();
  } else if (isBlueScreen) {
    blueScreen();
  } else if (now == 0) {
    la.display();
    la.update();
  } else if (now == 1) {
    lp.display();
    lp.update();
  } else if (now == 2) {
    lsc.display();
    lsc.update();
  } else if (now == 3) {
    pb.display();
    pb.update();
  }
  //一つのロード画面が1000回描画されたらブルースクリーンのフラグを立てる
  if (executionTime == 1000) {
    isBlueScreen = true;
    background(0,0,255);
  }
  executionTime++;
}

void mouseClicked() {
  clickCount++;
  executionTime = 0;
}



void blueScreen() {//ブルースクリーンのようにエラーメッセージを描画し続けるアニメーション
  push();
  fill(255);
  int w = 32;
  w += width/w * (frameCount%w);
  w -= 16;
  if (w == 16) {
    background(0, 0, 255);
  }
  
  int RANDOM = int(random(0, 6));//RANDOMの値によって描画される文字列を決定する。
  if (RANDOM == 0) {
    text("No access permission to the specified file.", 0, w);
  } else if (RANDOM == 1) {
    text("The specified file was not found.", 0, w);
  } else if (RANDOM == 2) {
    text("CRITICAL_PROCESS_DIED（0x000000EF）", 0, w);
  } else if (RANDOM == 3) {
    text("IRQL_NOT_LESS_OR_EQUAL（0x0000000A）", 0, w);
  } else if (RANDOM == 4) {
    text("SYSTEM_THREAD_EXCEPTION_NOT_HANDLED（0x0000007E）", 0, w);
  } else if (RANDOM == 5) {
    text("VIDEO_TDR_TIMEOUT_DETECTED（0x00000117）", 0, w);
  }
  pop();
}
