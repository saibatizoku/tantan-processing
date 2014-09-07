int ACTIVO = 0;
Nodo nodo_acuatico;

ConsolaSerial terminal;

boolean has_serial = false;
String inString;

void setup() {
  size(640, 570);
  nodo_acuatico = new Nodo(this);
  smooth();
}


void draw() {
  background(255);
  float coef_pantalla = 615/335;
  int px = floor(300/coef_pantalla);
  nodo_acuatico.dibujar();

  if (keyPressed) {
    int k = (int)key;
    //println(key);
    if (k == BACKSPACE) {
      terminal.borrar_char();
    } else if (k == CODED) {
//      println("Coded: " + k);
    } else {
      terminal.escribir_char(k);
    }
    if (has_serial) {
      myPort.write(k);
    }
    delay(250);
  }
  terminal.dibujar();
}

void activarEstanque(int indx) {
  for (int s = 0; s < nodo_acuatico.estanques.length; s = s + 1) {
    if (s == indx) {
      nodo_acuatico.estanques[s].activar();
    } else {
      nodo_acuatico.estanques[s].desactivar();
    }
  }
}

void serialEvent(Serial p) {
  String reg = "^(OD[0-9]):([0-9\\.]+)|^(T[0-9]):([0-9\\.]+)|^(pH):([0-9\\.]+)";
  inString = p.readString();
  texto_terminal += inString;
  String[][] matches = matchAll(inString, reg);
  //println(nodo_acuatico.nombre);
  try {
    // An array for the results
    String[] results = new String[matches.length];
  
    // We want group 1 for each result
    for (int i = 0; i < results.length; i++) {
      results[i] = matches[i][0];
      if ((matches[i][1] != null) & (matches[i][2] != null)) {
        nodo_acuatico.actualizar_sensor(matches[i][1], matches[i][2]);
      }
      if ((matches[i][3] != null) & (matches[i][4] != null)) {
        nodo_acuatico.actualizar_sensor(matches[i][3], matches[i][4]);
      }
      if ((matches[i][5] != null) & (matches[i][6] != null)) {
        nodo_acuatico.actualizar_sensor(matches[i][5], matches[i][6]);
      }
//      for (int j = 0 ; j < matches[i].length; j++) {
//        if (matches[i][j] != null) {
//          println(matches[i][j]);
//        }
//      }
    }
  }
  catch (Exception e) {
    
  }
}

