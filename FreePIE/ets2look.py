hSen = 750
vSen = 200

if starting:
  lastX = 0
  lastY = 0

thisX = xbox360[0].rightStickX * hSen
thisY = xbox360[0].rightStickY * vSen

mouse.deltaX = thisX - lastX
mouse.deltaY = lastY - thisY

lastX = thisX
lastY = thisY

