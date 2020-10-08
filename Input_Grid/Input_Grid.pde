/* //<>// //<>//
Jeter Gutierez, Ronuel Diaz
Due: May 21, 2018
Chinese Classifier
 */
int output_size= 6; //<>// //<>//
int input_size = 80*80;
float alpha = 0.1;
int max_iterations = 500;

float [][] weights;
int [] inputs;
PImage[] learning_data = new PImage[6];
XML training_data;
XML [] data;
float alph =0.2;
int bias= -1;

int ix =0;
int iy =0;
int fx=0;
int fy=0;
void setup() {
  println("L TO LOAD WEIGHT DATA");
  println("NUMBER 1-6 TO MANUALLY TRAIN AFTER DRAWING PRESS Q (PRESS 0 TO TRAIN INCOHERENT DATA)");
  println("S FOR AUTOMATIC TRAINING AND WEIGHT SAVING");
  println("ENTER TO CLASSIFY AFTER WEIGHT DATA IS LOADED OR TRAINING IS DONE");
  weights = new float[output_size][input_size]; 
  inputs = new int[input_size];
  training_data = loadXML("Training_Data.XML");
  data =training_data.getChildren("image");

  size(640, 640);
  smooth();
  stroke(0);
  background(255, 255, 255);

  learning_data[0]= loadImage("Eight.png");
  learning_data[1]= loadImage("Enter.png");
  learning_data[2]= loadImage("Man.png");
  learning_data[3]= loadImage("Destruction.png");
  learning_data[4]= loadImage("Assemble.png");
  learning_data[5]= loadImage("Perish.png");

  for (int i=0; i<output_size; i++) {
    learning_data[i].filter(THRESHOLD, 0.5);
    for (int j=0; j<input_size; j++) {
      weights[i][j]=random(-1, 1);
    }
  }
}


int[] convert(PImage img) {
  int[]bin = new int[80*80]; // holds our binary vector data 
  img.filter(THRESHOLD, 0.5); // change image to black and white 
  img.loadPixels();
  img.updatePixels();


  for (int i=0; i<80; i++) {
    for (int k=0; k<80; k++) {
      if (binary(img.get(i, k)).equals("11111111111111111111111111111111")) { // if white spot scanned then convert it into a 0 in our binary vector 
        bin[k*80+i]=0;
      } else {
        bin[k*80+i]=1; // convert dark pixel to 1 in binary vector
      }
    }
  }

  return bin;
}


void learn(int w_x, int[] inputs_, float act_value, int label ) { // Perceptron Learning rule 
  for (int i =0; i<weights[w_x].length; i++) {
    weights[w_x][i]=weights[w_x][i]+alph*(label-act_value)*inputs_[i];
  }
}


float activation_function (float sum) {

  return 1/(1+exp(-sum));
}

void train() {
  float sum=0;
  for (int v=0; v<max_iterations; v++) {
    for (int l=0; l<weights.length; l++) {
      for (int h=0; h<data.length; h++) {
        sum = 0; 
        int correct = data[h].getInt("corrrect_image");
        PImage train = loadImage(data[h].getString("path"));
        int [] bin = convert(train);

        for (int j=0; j<bin.length; j++) { // dot product of input vector and weight vector. 
          sum+=bin[j]*weights[l][j];
        }

        sum+=bias; // adding the bias 

        float act_value = activation_function(sum); 
        int true_value = 0;

        if (l+1==correct) {
          true_value=1;
        }
        learn(l, bin, act_value, true_value);
      }
    }
  }
}

void manual_train(PImage test, int correct) {
  float sum =0; 
  int [] bin = convert(test);
  for (int i = 0; i<weights.length; i++) {


    for (int j=0; j<weights[i].length; j++) { // Dot Product 

      sum+=bin[j]*weights[i][j];
    }

    sum+=bias;


    float act_value = activation_function(sum);

    int true_value=0;
    if (i+1==correct) {


      true_value=1;
    }
    learn(i, bin, act_value, true_value);
    sum=0;
  }
}

void print_weights() {

  for (int i=0; i<weights.length; i++) {
    for (int j =0; j<weights[i].length; j++) {
      print(weights[i][j], ",");
    }
    println();
  }
  println();
  println();
  println();
}

void testing (PImage test) {
  float sum =0; 
  float max = -9999;
  int index =0;
  int [] bin = convert(test);
  for (int i = 0; i<weights.length; i++) {
    for (int j=0; j<weights[i].length; j++) {

      sum+=bin[j]*weights[i][j];
    }
    sum+=bias;
    float act_value= activation_function(sum);

    if (act_value>max) {
      max = act_value;
      index=i;
    }
    sum=0;
  }

  if (max<0.000002) {
    println("CANT RECOGNIZE THIS CHARACTER");
  } else if (index+1==1) {
    println("EIGHT");
  } else if (index+1==2) {
    println("ENTER");
  } else if (index+1==3) {
    println("MAN");
  } else if (index+1==4) {
    println("DESTRUCTION");
  } else if (index+1==5) {
    println("ASSEMBLE");
  } else if (index+1==6) {
    println("PERISH");
  }
}

void save_weights() {
  PrintWriter output = createWriter("weight_data.txt");
  for (int i=0; i< weights.length; i++) {
    for (int j=0; j<weights[i].length; j++) {
      output.println(weights[i][j]);
    }
  }
  output.flush();
  output.close();
}

void load_weights() {
  BufferedReader reader = createReader("weight_data.txt");
  String[] weight_t;

  try {  

    for (int i=0; i<weights.length; i++) {
      for (int j=0; j<weights[i].length; j++) {
        String line = reader.readLine();
        weights[i][j] = float(line);
      }
    }
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void mouseDragged() {
  fill(0, 0, 0);
  strokeWeight(30);
  fx=mouseX;
  fy=mouseY;
  line(ix, iy, fx, fy);
  ix=fx;
  iy=fy;
}



void mousePressed() {
  ix=mouseX;
  iy=mouseY;
}

int correct_label = 0;

void keyPressed() {
  if (key=='q') {


    PImage screen =get();
    screen.resize(80, 80);
    manual_train(screen, correct_label);
    clear();
    background(255, 255, 255);
    save_weights();
  } else if (keyCode==ENTER) { 

    PImage screen =get();
    screen.resize(80, 80);
    testing(screen);
    clear();
    background(255, 255, 255);
  } else if (key=='l') {
    println("LOADING_DATA");
    load_weights();
    println("DATA_LOADED");
  } else if (key=='s') {
    println("TRAINING");
    train();
    save_weights();
    println("TRAINED");
  } else {

    correct_label=int(key)-48;
    println(correct_label);
  }
}
void draw() {
}
