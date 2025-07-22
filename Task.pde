class Task {
  String aciklama;
  String tarih;
  boolean tamamlandiMi;
  String oncelik; 
  String sorumlu;

  Task(String ga, String gt, String go, String gs) {
    aciklama = ga; tarih = gt; oncelik = go; sorumlu = gs;
    tamamlandiMi = false;
  }

void goster(float x, float y, color anaYazi, color griYazi, float faktor) {
  textFont(anaYaziTipi);
  
  float checkboxSize = 20 * faktor;
  float yaziBoyutu = 16 * faktor;
  float metinBasi = x + 30 * faktor;
  
  
  stroke(griYazi); noFill();
  if (tamamlandiMi) { fill(anaYazi); }
  rect(x, y - checkboxSize/1.5, checkboxSize, checkboxSize);

  
  textSize(yaziBoyutu);
  textAlign(LEFT, CENTER);
  
  if (tamamlandiMi) {
    fill(griYazi); stroke(griYazi);
    line(metinBasi, y, metinBasi + 220*faktor, y);
  } else {
    fill(anaYazi);
  }
  noStroke();
  text(aciklama, metinBasi, y);
  
  
  if (oncelik.equals("Yüksek")) { fill(255, 80, 80); }
  else if (oncelik.equals("Orta")) { fill(255, 160, 0); }
  else { fill(0, 180, 100); }
  text(oncelik, x + 300 * faktor, y);

  fill(anaYazi);
  text(sorumlu, x + 420 * faktor, y);

  fill(griYazi);
  text(tarih, x + 580 * faktor, y);

  
  fill(255, 80, 80);
  textSize(yaziBoyutu * 1.2);
  text("X", x + 720 * faktor, y);
  
  textAlign(LEFT, BASELINE);
}
}
