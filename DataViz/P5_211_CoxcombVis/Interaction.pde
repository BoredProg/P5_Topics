void mouseClicked() {
  if (mouseButton==LEFT){                                
    if (controlRow.isHovered() && !polar.isShifting()){   //if we are on a row button and the coxcomb isn't shifting alrady...
      polar.setCurrentIndex(controlRow.setCurrent());     //set the element where we are going                  
      polar.getCurrentElement().setSectorsGoal();         //say to all sectors they are going to travel                           
      polar.shiftingIs(true);                             //and tell the driver to go there
    } 
  }else{                                                  //button right toggles the 'scaler' display
    polar.toggleScaler();
  }
}

void mouseMoved(){
   if (mouseY<controlRow.getBorder()) {                   //if we are above (to save unnecesary checks)
     controlRow.hover(mouseX,mouseY);                     //check the button row hovers
   }else{                                                 //but if we are below
     if(controlRow.isHovered()){                          //it's impossible to us to be above 
       controlRow.hoverIs(false);                         //quite stupid, maybe, but necessary cause you can 'jump' with the mous
     }
   polar.getCurrentElement().hover(mouseX,mouseY);        //and check the polarElement hover
   }
}

void mouseDragged() { 
  polar.rotateElement(mouseX,pmouseX,.03);               //rotate the element, with an atenuation factor of .03 
}

void setCursor(){                                        //set the appropiate cursor
  if(controlRow.isHovered()) { 
    cursor(HAND);
  }else{ 
    cursor(CROSS);
  }
}
