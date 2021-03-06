ArrayList<Point> fog;

//coordonées de la camera
float camX;
float camY;
float camZ;
float fovY;
float fovX;

float vitesse = 1;

void setup(){
  
  size(800, 600, P3D);
  
  //coordonées par défaut de la camera
  camX = width/2;
  camY = height/2;
  camZ = (height/2) / tan(PI/6);
  fovY = PI/3;
  fovX = tan(fovY) * camZ;
  
  
  
  fog = new ArrayList();
  
  
  
  for(int i = 0; i < 10000; i++){
    
    fog.add(new Point(random(camZ)));
  }
  
}

void draw(){
  
  background(0);
  
  for(int i = fog.size() - 1; i >= 0; i--){    //On parcoure l'ArrayList a l'envers pour pouvoir supprimer et creer de nouveaux objets sans crash
    
    Point p = fog.get(i);
    
    float d = dist(p.x, p.y, p.z, camX, camY, camZ);    //la distance du point a la camera
    
    strokeWeight(1000 / (tan(fovY) * d));    //l'épaisseur du point en fonction de la distance a la camera
    
    stroke(p.couleur);
    point(p.x, p.y, p.z);
    
    p.z += vitesse * noise(1, p.phase + millis() / 2000.0);    //On fait avancer le point dans la coordonnée Z (vers la camera)
    p.x += noise(2, p.phase + millis() / 1000.0) - .5;
    p.y += noise(3, p.phase + millis() / 1000.0) - .5;
    
    //Calcul des angles en X et Y entre la caméra et le points pour déterminer s'il est dans le champ de vision
    float angleX = atan((p.x-camX) / (p.z-camZ));
    float angleY = atan((p.y-camY) / (p.z-camZ));
    
    if(abs(angleY) > fovY/2 || abs(angleX) > fovX/2 || p.z > camZ){    //Si un point est en dehors du champ de vision, alors il est supprimé et un autre point est crée
      
      fog.remove(i);
      fog.add(new Point(0));
    }
  }
  
  println(frameRate);
}


class Point{
  
  float x;
  float y;
  float z;
  color couleur;
  float phase;    //Phase aléatoire dont sera déduite la vitesse du point
  
  Point(float z){
    
    x = random(width);
    y = random(height);
    this.z = z;
    couleur = color(255, random(50, 200), 0);    //couleur dans les tons chauds (orange-jaunatre)
    phase = random(100);
  }
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  vitesse *= (1-e/5);
}