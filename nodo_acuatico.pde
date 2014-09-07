PFont font_mono16, font_30, font_64;

class Nodo {
  PApplet parent;
  String nombre;
  FloatList pH, od1, od2, od3, od4, t1, t2, t3, t4;
  Estanque[] estanques = new Estanque[4];

  Nodo(PApplet _parent) {
    parent = _parent;
    nombre = "Nodo Acuatico";
    println("Nodo inicializado");
    font_mono16 = loadFont("LiberationMono-Bold-16.vlw");
    font_30 = loadFont("UbuntuMono-Regular-30.vlw");
    font_64 = loadFont("Ubuntu-64.vlw");

    estanques[0] = new Estanque(15, 10, "1");
    estanques[1] = new Estanque(330, 10, "2");
    estanques[2] = new Estanque(15, 195, "3");
    estanques[3] = new Estanque(330, 195, "4");
    terminal = new ConsolaSerial(parent, 15, 385);
  }
  
  void actualizar_sensor(String tipo, String valor) {
    float val = float(valor);
    if (tipo.equals("OD1")) {
      estanques[0].sensores[0].actualizar(val);
//      estanques[0].dibujar();
      od1.append(val);
    } else if (tipo.equals("OD2")) {
      estanques[1].sensores[0].actualizar(val);
      od2.append(val);
    } else if (tipo.equals("OD3")) {
      estanques[2].sensores[0].actualizar(val);
      od3.append(val);
    } else if (tipo.equals("OD4")) {
      estanques[3].sensores[0].actualizar(val);
      od4.append(val);
    } else if (tipo.equals("T1")) {
      estanques[0].sensores[1].actualizar(val);
      od2.append(val);
    } else if (tipo.equals("T2")) {
      estanques[1].sensores[1].actualizar(val);
      od3.append(val);
    } else if (tipo.equals("T3")) {
      estanques[2].sensores[1].actualizar(val);
      od4.append(val);
    } else if (tipo.equals("T4")) {
      estanques[3].sensores[1].actualizar(val);
      od2.append(val);
    }
  }

  void dibujar() {
    for (int s = 0; s < estanques.length; s = s + 1) {
      estanques[s].dibujar();
    }
  }
}
class Sensor {
  String nombre = "Sensor";
  String unidades;
  float valor;
  int x = 0;
  int y = 0;
  boolean activo = false;

  Sensor(String _nombre, String _unidades) {
    nombre = _nombre;
    unidades = _unidades;
  }
  
  void actualizar(float _val) {
    valor = _val;
    println("Actualizando " + valor);
  }

  void dibujar(int _x, int _y) {
    x = _x;
    y = _y;
    int h = 30;
    int w = 85;
    fill(255);
    rect(x+100, y+20, w, h);
    dibujar_texto();
  }

  void dibujar_texto() {
    fill(0);
    textFont(font_30);
    textSize(30);
    String txt;
    if (unidades == "kW") {
      txt = nf(valor, 1, 3) + " " + unidades; 
      text(txt, x+105, y+45);
    } else {
      txt = nf(valor, 2, 1) + " " + unidades; 
      text(txt, x+125, y+45);
    }
  }
}

class Estanque {
  String nombre;
  int x, y;
  int w = 74;
  int h = 490;
  Sensor[] sensores = new Sensor[4];
  boolean activo = false;

  Estanque(int _x, int _y, String _nombre) {
    x = _x;
    y = _y;
    nombre = _nombre;
    sensores[0] = new Sensor("OD", "mg/ml");
    sensores[1] = new Sensor("T", "°C");
    sensores[2] = new Sensor("kW", "kW");
    sensores[3] = new Sensor("V", "V");
  }
  void activar() {
    activo = true;
  }

  void desactivar() {
    activo = false;
  }
  boolean seleccionado() {
    return overRect(x+8, y+8, 74, 75);
  }
  void dibujar() {
    noFill();
    stroke(0, 2, 184);
    strokeWeight(7);
    rect(x, y, 300, 175, 30);

    textFont(font_mono16);
    stroke(0);    
    strokeWeight(1);
    if (activo) {
      //fill(57, 170, 116, 170);
      //rect(x+12, y+5, 74, 490);
      //      noFill();
      //      noStroke();
      //      rect(x-12, y-130, 74, 75);
      stroke(0);
      fill(0, 30, 50);
      textFont(font_mono16);
      textSize(16);
      text("Estanque", x+15, y+30);
      textFont(font_64);
      textSize(64);
      text(nombre, x+15, y+80);
    } else {
      //fill(247, 247, 247, 40);
      //rect(x+12, y+10, 74, 490);
      //fill(57, 70, 86, 40);
      //rect(x+8, y+8, 74, 75);
      stroke(50);
      fill(50);
      textFont(font_mono16);
      textSize(16);
      text("Estanque", x+15, y+30);
      textFont(font_64);
      textSize(50);
      text(nombre, x+15, y+80);
      fill(185);
    }
    for (int s = 0; s < sensores.length; s = s + 1) {
      //
    }
    sensores[0].dibujar(x, y);
    sensores[1].dibujar(x, y+30);
    sensores[2].dibujar(x, y+60);
    sensores[3].dibujar(x, y+90);
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  for (int s = 0; s < nodo_acuatico.estanques.length; s = s + 1) {
    if (nodo_acuatico.estanques[s].seleccionado()) {
      activarEstanque(s);
    }
  }
  if (nodo_acuatico.estanques[0].seleccionado()) {
    println("E1 seleccionado");
    nodo_acuatico.estanques[0].activar();
    nodo_acuatico.estanques[1].desactivar();
    nodo_acuatico.estanques[2].desactivar();
    nodo_acuatico.estanques[3].desactivar();
  } else if (nodo_acuatico.estanques[1].seleccionado()) {
    println("E2 seleccionado");
    nodo_acuatico.estanques[0].desactivar();
    nodo_acuatico.estanques[1].activar();
    nodo_acuatico.estanques[2].desactivar();
    nodo_acuatico.estanques[3].desactivar();
  } else if (nodo_acuatico.estanques[2].seleccionado()) {
    println("E3 seleccionado");
    nodo_acuatico.estanques[0].desactivar();
    nodo_acuatico.estanques[1].desactivar();
    nodo_acuatico.estanques[2].activar();
    nodo_acuatico.estanques[3].desactivar();
  } else if (nodo_acuatico.estanques[3].seleccionado()) {
    println("E4 seleccionado");
    nodo_acuatico.estanques[0].desactivar();
    nodo_acuatico.estanques[1].desactivar();
    nodo_acuatico.estanques[2].desactivar();
    nodo_acuatico.estanques[3].activar();
  } else {
    print("se oprimio raton: ");
    println(mouseX+" "+mouseY);
    nodo_acuatico.estanques[0].desactivar();
    nodo_acuatico.estanques[1].desactivar();
    nodo_acuatico.estanques[2].desactivar();
    nodo_acuatico.estanques[3].desactivar();
  }
}

