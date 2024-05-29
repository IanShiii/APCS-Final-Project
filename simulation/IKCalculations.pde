public static class IKCalculations {
  private static PVector[] getIntersections(PVector center1, float radius1, PVector center2, float radius2) {
    PVector distanceVector = center2.copy().sub(center1);
    float distance = distanceVector.mag();
    
    float a = (float)Math.max((Math.pow(radius1, 2) - Math.pow(radius2, 2) + Math.pow(distance, 2))/(2*distance), 0);
    
    float heightMagnitude = (float)Math.sqrt(Math.max(Math.pow(radius1, 2) - Math.pow(a, 2), 0));
    PVector heightVector = new PVector((float)(-heightMagnitude * Math.sin(distanceVector.heading())), (float)(heightMagnitude * Math.cos(distanceVector.heading())));
    
    // Calculate intersections' position
    PVector point = center1.copy().add(distanceVector.copy().normalize().mult(a));
    PVector intersection1 = point.copy().add(heightVector);
    PVector intersection2 = point.copy().sub(heightVector);
    
    PVector[] intersections = {intersection1, intersection2};
    return intersections;
  }
  
  // not sure why this works lol
  private static boolean isTriangleValid(float side1, float side2, float side3) {
    return (side1 + side2) >= side3 || (side1 + side3) >= side2 || (side2 + side3) >= side1;
  }
  
  private static float findSide(float min, float max, float side1, float side2) {
    for (float side = max; side >= min; side -= 0.1) {
      if (isTriangleValid(side, side1, side2)) {
        return side;
      }
    }
    return 0.0;
  }
  
  public static float[] calculateAngles(float[] ligamentLengths, PVector target, float maxDistance, PVector pole) {
    ArrayList<Float> anglesArrList = new ArrayList<Float>(ligamentLengths.length);
    
    if (target.mag() > maxDistance) {
      target.normalize().mult(maxDistance);
    }
    PVector currentSideVector = target.copy();
    
    for (int i = ligamentLengths.length - 1; i > 0; i--) {
      float currentSide = currentSideVector.mag();
      
      //find possible side
      float[] ligamentLengthsUpToLigament = new float[i];
      arrayCopy(ligamentLengths, ligamentLengthsUpToLigament, i);
      float totalLengthUpToLigament = 0;
      for (float ligamentLength : ligamentLengthsUpToLigament) {
        totalLengthUpToLigament += ligamentLength;
      }
      float newSide = findSide(0, totalLengthUpToLigament, ligamentLengths[i], currentSide);
      
      // find intersections
      PVector[] intersections;
      if (i != 1) {
        intersections = getIntersections(currentSideVector, ligamentLengths[i], new PVector(0,0), newSide);
      }
      else {
        intersections = getIntersections(currentSideVector, ligamentLengths[i], new PVector(0,0), ligamentLengths[0]);
      }
      
      // find intersections nearest to pole
      PVector intersection;
      if (intersections[0].copy().sub(pole).mag() < intersections[1].copy().sub(pole).mag()) {
        intersection = intersections[0];
      }
      else {
        intersection = intersections[1];
      }
      
      anglesArrList.add(0, Float.valueOf(currentSideVector.copy().sub(intersection).heading()));
      currentSideVector = intersection;
    }
    
    anglesArrList.add(0, Float.valueOf(currentSideVector.heading()));
    
    float[] angles = new float[ligamentLengths.length];
    for (int i = 0; i < angles.length; i++) {
      angles[i] = anglesArrList.get(i);
    }
    
    return angles;
  }
}
