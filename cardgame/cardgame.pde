Card[] cards = new Card[53]; // array of card objects. [0] not in use.
StringList deck; // file list for card images.
boolean dragAnyCard = false;
int heldCardId = 0; // Global variable to store local object id of held card.
int cardWidth = 69; // card images: 691px x 1056px.
int cardHeight = 105;
int edgePushX = 100; // push card start position right.
int edgePushY = 50; // push card start position down.
float cRow, cCol; // initial card position slot.

void setup()
{
  println("Setup in progress...\n");
  size(960, 1040);
  frameRate(30);
  deck = new StringList("red_back.png", "AC.png", "AD.png", "AH.png", "AS.png", "2C.png", "2D.png", "2H.png", "2S.png", "3C.png","3D.png", "3H.png", "3S.png", "4C.png", "4D.png", "4H.png", "4S.png", "5C.png", "5D.png", "5H.png", "5S.png", "6C.png", "6D.png", "6H.png", "6S.png", "7C.png", "7D.png", "7H.png", "7S.png", "8C.png", "8D.png", "8H.png", "8S.png", "9C.png", "9D.png", "9H.png", "9S.png", "10C.png", "10D.png", "10H.png", "10S.png", "JC.png", "JD.png", "JH.png", "JS.png", "QC.png", "QD.png", "QH.png", "QS.png", "KC.png", "KD.png", "KH.png", "KS.png");
  // deck.get(n)  LIST:  C>D>H>S  CARDBACK-A-2-3-4-5-6-7-8-9-10-J-Q-K

  for(int i = 1; i <= 52; i++) // setup cards starting pos and create cards.
  {
    float rx = edgePushX + cardWidth/2 + cCol*100; // card start pos X.
    float ry = edgePushY + cardHeight/2 + cRow*125; // card start pos Y.
    
    cards[i] = new Card(i, deck.get(i), rx, ry); // create card object.
    
    cCol++; // Calc. start pos for next card:
    if(i % 8 == 0) 
    { // 8 cards per row.
      cRow++;
      cCol = 0;
    }
    println("Created " + i + " cards.");
  }
  println("\nSetup complete.\n");
} // setup end.

void draw()
{
  background(53,101,77); // poker green.
  /* Doesn't work yet - Trying to draw held card on top.
  while(dragAnyCard && heldCardId != 0)
  {
    cards[heldCardId].update();
  } */
  for(int i = 1; i <= 52; i++) // update all cards.
  {
    cards[i].update(); 
    /* Doesn't work yet -..-
    if(!dragAnyCard || heldCardId != i) 
    {
      cards[i].update();
    } */
  }
}
class Card
{ // This is a class: instructions for creating and updating card objects.
  PImage imgsrc; // image type variable (?).
  boolean hoverCard, dragCard; // Track mouse interaction.
  int id;
  float x, y, xOffset, yOffset, xGrid, yGrid;
  float w = cardWidth;
  float h = cardHeight;
  float gridSize = 25; // cards align to grid when dropped.
  float boundingBox = 1; // mouse hover area scale compared to card size.

  Card(int i, String img, float bx, float by)
  { // This function is basically setup() for objects (name = class name).
    imageMode(CENTER); // center img around its X/Y pos.
    imgsrc = loadImage(img); // load fed image (from /data folder by default).
    hoverCard = false;
    dragCard = false;
    id = i;
    xOffset = 0;
    yOffset = 0;
    x = bx;
    y = by;
    boundingBox = boundingBox/2; // This makes 1 == card size instead of 0.5.
    println("object created with ID: " + i + " / IMG: " + deck.get(i));
  } // card() end.

  void update() // Update position and draw image in draw().
  { /* Check if a card is eligible for hover/click interaction:
    Is the mouse X/Y pos GREATER than:
    the X/Y pos of the (center of the) card ..
    MINUS half the width/height of the card. (half means boundingBox == 0.5)
      AND Is the mouse X/Y pos LESS than:
    the X/Y pos of the (center of the) card
    PLUS half the width/height of the card.
      AND no card is held or this card is held: */
    if (mouseX > x-w*boundingBox && mouseX < x+w*boundingBox &&
        mouseY > y-h*boundingBox && mouseY < y+h*boundingBox &&
        (!dragAnyCard || dragCard))
    {
      hoverCard = true;
    } 
    else
    {
      hoverCard = false;
    }

    if(mousePressed && hoverCard)
    { // Hover and click a card to pick it up.
      dragAnyCard = true;
      dragCard = true;
      if(heldCardId != int(id)) println("Dragged card id: " + id);
      heldCardId = id;
      
    }
    if(!mousePressed)
    { // If the mouse is not pressed, no cards are being dragged.
      dragAnyCard = false;
      dragCard = false;
    }
    
    if(dragCard)
    { // Offset prevents card from centering on mouse pos when picking up.
      x = mouseX-xOffset;
      y = mouseY-yOffset;
    }
    else 
    { // Lazy Mans Grid. When card is dropped: align to nearest % gridSize.
      xGrid = round(x/gridSize)*gridSize;
      yGrid = round(y/gridSize)*gridSize;
      x = xGrid;
      y = yGrid;  
    }

    xOffset = mouseX-x; // X distance from card to mouse.
    yOffset = mouseY-y; // Y distance from card to mouse.
    
    // Draw card: image url, x pos, y pos, width, height.
    image(imgsrc, x, y, w, h);
  } // update() end.
} // Card class end.
