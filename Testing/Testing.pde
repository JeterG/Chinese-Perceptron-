int ix =0;
int iy =0;
int fx=0;
int fy=0;

int i = 232;
void setup(){
size(640,640);
background(255,255,255);

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
String label= "EIGHT";
void keyPressed(){
  if(keyCode==ENTER){
  PImage screen = get();
  screen.resize(80,80);
  screen.save(str(i)+".png");
  i++;
  clear();
  background(255,255,255);
  }else{
  correct_label = int(key)-48;
  println(correct_label);
  if(correct_label==1){
    label="EIGHT";
  }else if (correct_label==2){
    label="ENTER";
  }else if (correct_label==3){
    label="MAN";
  }else if (correct_label==4){
  label="DESTRUCTION";
  }else if (correct_label==5){
  label="ASSEMBLE";
  }else if (correct_label==6){
  label="PERISH";
  }
  }
}
void draw() {
}
