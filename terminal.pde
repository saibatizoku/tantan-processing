import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
Serial myPort;
int LINE_FEED = 10;
Textarea myTextarea;
String texto_terminal = "";

class ConsolaSerial {
  int c_x, c_y;
  String texto;
  String TEXTO_DEFAULT;
  boolean REINICIAR_TEXTO = true;
  PApplet parent;


  ConsolaSerial(PApplet _parent, int _x, int _y) {
    c_x = _x;
    c_y = _y;
    texto =  "";
    TEXTO_DEFAULT = "Consola del puerto serial\n******************";
    parent = _parent;
    println(Serial.list());
    cp5 = new ControlP5(parent);
    myTextarea = cp5.addTextarea("txt")
      .setPosition(c_x+20, c_y+10)
        .setSize(250, 155)
          .setFont(font_mono16)
            .setLineHeight(16)
              .setColor(color(255))
                .setColorBackground(color(155, 100, 100))
                  .setColorForeground(color(155, 100, 100));
    ;
    try {
      myPort = new Serial(parent, "/dev/ttyACM0", 38400);
      myPort.bufferUntil(LINE_FEED);
      has_serial = true;
    } 
    catch (Exception e) {
      println("No hubo puerto serial");
      has_serial = false;
    }
  }
  void dibujar() {
    fill(191, 193, 255);
    stroke(0, 2, 184);
    strokeWeight(7);
    rect(c_x, c_y, 610, 175, 25);


    if (texto_terminal.length() > 0) {
      myTextarea.setText(texto_terminal);
    } else {
      myTextarea.setText(TEXTO_DEFAULT);
    }

    //    fill(0);
    //    text(texto, c_x + 10, c_y + 40);
    //    strokeWeight(1);
  }
  void escribir_char(int txt) {
    if (REINICIAR_TEXTO) {
      texto = "";
      REINICIAR_TEXTO = false;
    }
    texto += (char)txt;
    //println(txt);
  }

  void borrar_char() {
    println("borrando " + texto);
    if (texto.length() > 0) {
      texto = texto.substring(0, texto.length()-1);
    }
    println("borrado" + texto);
  }
}

