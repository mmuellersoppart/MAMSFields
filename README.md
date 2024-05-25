# MAMSFields

FieldViews being used. 

```Swift
switch match.sport {
  case Sport.soccer:
    SoccerFieldView(radians: radians, fillColor: Color(red: 55/255, green: 199/255, blue: 92/255), strokeWidth: lineWidth, scale: scale, isMaximized: true)
  case Sport.iceHockey:
    IceHockeyFieldView(radians: radians, fillColor: Color(red: 150/255, green: 180/255, blue: 255/255), strokeWidth: lineWidth, scale: scale, isMaximized: true)
  case Sport.basketball:
    BasketballFieldView(radians: radians, fillColor: Color(red: 191/255, green: 170/255, blue: 139/255), strokeWidth: lineWidth, scale: scale, isMaximized: true)
  case Sport.volleyball:
    VolleyballFieldView(radians: radians, fillColor: Color(red: 90/255, green: 169/255, blue: 255/255), freeZoneFillColor: Color(red: 253/255, green: 220/255, blue: 86/255), strokeWidth: lineWidth, scale: scale, isMaximized: true)
}
```
