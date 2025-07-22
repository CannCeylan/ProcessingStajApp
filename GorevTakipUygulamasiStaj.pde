
float buyutmeFaktoru = 1.3;
int gorevListesiBaslangicY;
PFont anaYaziTipi;
boolean geceModuAktifMi = false;

color arkaplanRengi;
color yaziRengi;
color griYaziRengi;
color arayuzArkaplanRengi; 
color kirmiziButonRengi = color(255, 0, 0);
import controlP5.*;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.io.File; 


ControlP5 cp5;
ArrayList<Task> gorevler;
String yeniGorevMetni = "";
int aktifFiltre = 0; 

void setup() {
  size(1440, 900);
  

  anaYaziTipi = loadFont("Arial-Turkish-48.vlw"); 
  //font = createFont("DejaVuSans.ttf", 16);
  textFont(anaYaziTipi);

  
  gorevler = new ArrayList<Task>();
  cp5 = new ControlP5(this);

  
  int uiY = 40; 
  int uiYukseklik = (int)(35 * buyutmeFaktoru);
  int mevcutX = 50;
  int bosluk = (int)(10 * buyutmeFaktoru);
  int genislik;

  genislik = (int)(200 * buyutmeFaktoru);
  cp5.addTextfield("yeniGorevMetni").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik).setAutoClear(false);
  mevcutX += genislik + bosluk;

  genislik = (int)(110 * buyutmeFaktoru);
  DropdownList oncelikMenusu = cp5.addDropdownList("oncelikSecimi").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik*3);
  oncelikMenusu.addItem("Yuksek", 0); oncelikMenusu.addItem("Orta", 1); oncelikMenusu.addItem("Dusuk", 2);
  oncelikMenusu.setLabel("Orta");
  mevcutX += genislik + bosluk;
  
  genislik = (int)(130 * buyutmeFaktoru);
  cp5.addTextfield("yeniSorumluMetni").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik).setLabel("Sorumlu...").setAutoClear(false);
  mevcutX += genislik + bosluk;

  genislik = (int)(70 * buyutmeFaktoru);
  cp5.addButton("gorevEkle").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik).setLabel("Ekle");
  mevcutX += genislik + bosluk + (bosluk*2); 
  
  genislik = (int)(150 * buyutmeFaktoru);
  DropdownList filtreMenusu = cp5.addDropdownList("filtrele").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik*3);
  filtreMenusu.addItem("Tumu", 0); filtreMenusu.addItem("Tamamlananlar", 1); filtreMenusu.addItem("Yapılacaklar", 2);
  filtreMenusu.setLabel("Tumu");
  mevcutX += genislik + bosluk;
  
  genislik = (int)(90 * buyutmeFaktoru);
  cp5.addButton("veriyiKaydet").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik).setLabel("Kaydet");
  mevcutX += genislik + bosluk;
  
  cp5.addButton("verileriYukle").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik).setLabel("Yukle");
  mevcutX += genislik + bosluk;

  cp5.addButton("temaDegistir").setPosition(mevcutX, uiY).setSize(genislik, uiYukseklik).setLabel("Tema");

  int yaziBoyutu = (int)(14 * buyutmeFaktoru);
  for (ControllerInterface<?> c : cp5.getAll()) {
    if (c instanceof Button) {
      ((Button)c).getCaptionLabel().getFont().setSize(yaziBoyutu);
    } else if (c instanceof DropdownList) {
      ((DropdownList)c).getCaptionLabel().getFont().setSize(yaziBoyutu);
      ((DropdownList)c).getValueLabel().getFont().setSize(yaziBoyutu);
    } else if (c instanceof Textfield) {
      ((Textfield)c).getCaptionLabel().getFont().setSize(yaziBoyutu);
      ((Textfield)c).getValueLabel().getFont().setSize(yaziBoyutu);
    }
  }

  gorevListesiBaslangicY = uiY + uiYukseklik + (int)(40 * buyutmeFaktoru); 
  temaGuncelle();
  verileriYukle(); 
}

void draw() {
  background(arkaplanRengi);
  
  int gorunenGorevSayaci = 0;
  for (int i = 0; i < gorevler.size(); i++) {
    Task mevcutGorev = gorevler.get(i);
    
    boolean goreviGoster = false;
    if (aktifFiltre == 0) {
      goreviGoster = true;
    } else if (aktifFiltre == 1 && mevcutGorev.tamamlandiMi) {
      goreviGoster = true;
    } else if (aktifFiltre == 2 && !mevcutGorev.tamamlandiMi) {
      goreviGoster = true;
    }
    
   if (goreviGoster) {
   float yPos = gorevListesiBaslangicY + gorunenGorevSayaci * (50 * buyutmeFaktoru); 
  
  mevcutGorev.goster(50, yPos, yaziRengi, griYaziRengi, buyutmeFaktoru);
  gorunenGorevSayaci++;
}
  }
}

void mousePressed() {
  if (cp5.isMouseOver()) return;
  
  int gorunenGorevSayaci = 0;
  int silinecekGorevIndexi = -1;

  for (int i = 0; i < gorevler.size(); i++) {
    Task mevcutGorev = gorevler.get(i);
    boolean gorunurMu = (aktifFiltre == 0) || (aktifFiltre == 1 && mevcutGorev.tamamlandiMi) || (aktifFiltre == 2 && !mevcutGorev.tamamlandiMi);

    if (gorunurMu) {
       float yPos = gorevListesiBaslangicY + gorunenGorevSayaci * (50 * buyutmeFaktoru);
      float xPos = 50;
      float checkboxSize = 20 * buyutmeFaktoru;
      
      
      if (mouseX > xPos && mouseX < xPos + checkboxSize && mouseY > yPos - checkboxSize/1.5 && mouseY < yPos + checkboxSize/2.5) {
        mevcutGorev.tamamlandiMi = !mevcutGorev.tamamlandiMi;
        return;
      }
      
      
      if (dist(mouseX, mouseY, xPos + 720 * buyutmeFaktoru, yPos) < 15 * buyutmeFaktoru) {
        silinecekGorevIndexi = i;
        break;
      }
      
      gorunenGorevSayaci++;
    }
  }
  
  if (silinecekGorevIndexi != -1) {
    gorevler.remove(silinecekGorevIndexi);
  }
}

public void gorevEkle() {
  String aciklama = cp5.get(Textfield.class, "yeniGorevMetni").getText();
  String secilenOncelik = cp5.get(DropdownList.class, "oncelikSecimi").getLabel();
  String sorumlu = cp5.get(Textfield.class, "yeniSorumluMetni").getText();
  
 
  if (sorumlu.trim().isEmpty()) {
    sorumlu = "Atanmadı";
  }
  
 
  if (!aciklama.trim().isEmpty()) {
    SimpleDateFormat formatlayici = new SimpleDateFormat("dd.MM.yyyy");
    String bugununTarihi = formatlayici.format(new Date());
    
    
    gorevler.add(new Task(aciklama, bugununTarihi, secilenOncelik, sorumlu));
    
    
    cp5.get(Textfield.class, "yeniGorevMetni").clear();
    cp5.get(Textfield.class, "yeniSorumluMetni").setText(""); 
  }
}
public void filtrele(int secilenDeger) {
  aktifFiltre = secilenDeger;
}


public void veriyiKaydet() {
  JSONArray jsonGorevler = new JSONArray();
  for (Task gorev : gorevler) {
    JSONObject jsonGorev = new JSONObject();
    jsonGorev.setString("aciklama", gorev.aciklama);
    jsonGorev.setString("tarih", gorev.tarih);
    jsonGorev.setBoolean("tamamlandiMi", gorev.tamamlandiMi);
    jsonGorev.setString("oncelik", gorev.oncelik);
    jsonGorev.setString("sorumlu", gorev.sorumlu); 
    jsonGorevler.append(jsonGorev);
  }
  saveJSONArray(jsonGorevler, "data/gorevler.json");
  println("Veriler başarıyla kaydedildi!");
}


public void verileriYukle() {
  File dosya = new File(dataPath("gorevler.json"));
  if (!dosya.exists()) {
    println("Kayit dosyasi bulunamadi.");
    return;
  }
  
  JSONArray jsonGorevler = loadJSONArray(dataPath("gorevler.json"));
  gorevler.clear();
  
  for (int i = 0; i < jsonGorevler.size(); i++) {
    JSONObject jsonGorev = jsonGorevler.getJSONObject(i);
    String aciklama = jsonGorev.getString("aciklama");
    String tarih = jsonGorev.getString("tarih");
    boolean tamamlandiMi = jsonGorev.getBoolean("tamamlandiMi");
    String oncelik = jsonGorev.getString("oncelik", "Orta");
    String sorumlu = jsonGorev.getString("sorumlu", "Atanmadı"); 
    
    Task yeniGorev = new Task(aciklama, tarih, oncelik, sorumlu); 
    yeniGorev.tamamlandiMi = tamamlandiMi;
    gorevler.add(yeniGorev);
  }
  println("Veriler başarıyla yüklendi!");
}
public void temaDegistir() {
  geceModuAktifMi = !geceModuAktifMi; 
  temaGuncelle(); 
}

void temaGuncelle() {
  if (geceModuAktifMi) {
    
    arkaplanRengi = color(40, 42, 54);
    yaziRengi = color(248, 248, 242);
    griYaziRengi = color(150, 150, 150);
    arayuzArkaplanRengi = color(68, 71, 90);
  } else {
    
    arkaplanRengi = color(240);
    yaziRengi = color(0);
    griYaziRengi = color(100);
    arayuzArkaplanRengi = color(200);
  }
  
  cp5.setColorBackground(arayuzArkaplanRengi);
  cp5.setColorForeground(kirmiziButonRengi);
  cp5.setColorActive(kirmiziButonRengi);
  
  
  for (ControllerInterface<?> c : cp5.getAll()) {
    
    if (c instanceof Button) {
      ((Button) c).getCaptionLabel().setColor(yaziRengi);
    } 
    
    else if (c instanceof DropdownList) {
      ((DropdownList) c).getCaptionLabel().setColor(yaziRengi);
    }
    else if (c instanceof Textfield) {
      ((Textfield) c).getCaptionLabel().setColor(yaziRengi);
    }
  }
}
