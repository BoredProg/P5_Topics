void keyPressed ()
{
  if (keyCode == KeyEvent.VK_PLUS) t.increaseDepth();
  if (keyCode == KeyEvent.VK_MINUS) t.decreaseDepth();
  if (keyCode == KeyEvent.VK_O) showImg = !showImg;
if (keyCode == KeyEvent.VK_SPACE) 
  {
    ng.createImg();
    t.update(ng.getImage());
    count = 0;
  }
  
}



