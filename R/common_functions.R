# adds a bunch of commonly used functions 

MsToKmh = function(x) {
  return(3.6 * x)
}

KmhToMs = function(x) {
  return(x / 3.6)
}

alphaRightFrontTireD = function(dist, widthFrontTiresA_m, dObsCurb_m, widthRoad_m) {
  atan((dObsCurb_m + widthRoad_m/2 + widthFrontTiresA_m/2) / dist)
}

alphaLeftRearTireD = function(dist, widthFrontTiresA_m, dObsCurb_m, widthRoad_m,distPsrFrontRearAxle_m) {
  atan((dObsCurb_m + widthRoad_m/2 - widthFrontTiresA_m/2) / (dist+distPsrFrontRearAxle_m))
}

# Define the cosine similarity function
cosineSim = function(A, B) {
  return(sum(A * B) / (norm(A) * norm(B)))
}

# Define the function to calculate leftBottomCarXYZorigin
leftBottomCarXYZorigin = function(t, widthVeh) {
  return(c((dObsCurb + widthRoad/2 - widthVeh/2), 0, r[t]) - viewpointXYZ)
}

# Define the function to calculate rightTopCarXYZorigin
rightTopCarXYZorigin = function(t, widthVeh, heightCar) {
  return(c((dObsCurb + widthRoad/2 + widthVeh/2), heightCar, r[t]) - viewpointXYZ)
}

# Define the function to calculate alphaDiagCosSim
alphaDiagCosSim = function(t, widthVeh, heightCar) {
  return(acos(cosineSim(leftBottomCarXYZorigin(t, widthVeh), 
                        rightTopCarXYZorigin(t, widthVeh, heightCar))))
}

# Define the function to calculate leftBottomCarXYZoriginD
leftBottomCarXYZoriginD = function(dist, widthVeh) {
  return(c((dObsCurb + widthRoad/2 - widthVeh/2), 0, dist) - viewpointXYZ)
}

# Define the function to calculate rightTopCarXYZoriginD
rightTopCarXYZoriginD = function(dist, widthVeh, heightCar) {
  return(c((dObsCurb + widthRoad/2 + widthVeh/2), heightCar, dist) - viewpointXYZ)
}

# Define the function to calculate alphaDiagCosSimD
alphaDiagCosSimD = function(dist, widthVeh, heightCar) {
  return(acos(cosineSim(leftBottomCarXYZoriginD(dist, widthVeh), 
                        rightTopCarXYZoriginD(dist, widthVeh, heightCar))))
}

# Define the function to calculate the change rate of width
changeRateWidth = function(t, widthVeh) {
  # You need to define alphaWidth function for this calculation
  return(D(alphaWidth(t, widthVeh), t))
}