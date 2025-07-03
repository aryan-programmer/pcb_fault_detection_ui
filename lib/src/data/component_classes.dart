class ResultClass {
  final int i;
  final String name;
  const ResultClass({required this.i, required this.name});
}

enum ComponentClass implements ResultClass {
  battery(0, "Battery"),
  button(1, "Button"),
  buzzer(2, "Buzzer"),
  capacitor(3, "Capacitor"),
  clock(4, "Clock"),
  connector(5, "Connector"),
  diode(6, "Diode"),
  display(7, "Display"),
  fuse(8, "Fuse"),
  heatsink(9, "Heat Sink"),
  ic(10, "IC"),
  inductor(11, "Inductor"),
  led(12, "LED"),
  pads(13, "Pads"),
  pins(14, "Pins"),
  potentiometer(15, "Potentiometer"),
  relay(16, "Relay"),
  resistor(17, "Resistor"),
  switch_(18, "Switch"),
  transducer(19, "Transducer"),
  transformer(20, "Transformer"),
  transistor(21, "Transistor");

  @override
  final int i;
  @override
  final String name;
  const ComponentClass(this.i, this.name);

  static final Map<int, ComponentClass> INT_TO_COMPONENT = Map.unmodifiable(
    Map.fromEntries(ComponentClass.values.map((v) => MapEntry(v.i, v))),
  );
}

enum TrackDefectClasses implements ResultClass {
  short(0, "Short"),
  spur(1, "Spur"),
  spuriousCopper(2, "Spurious copper"),
  open(3, "Open"),
  mouseBite(4, "Mouse bite"),
  holeBreakout(5, "Hole breakout"),
  conductorScratch(6, "Conductor scratch"),
  conductofForeignObject(7, "Conductor foreign object"),
  baseMaterialForeignObject(8, "Base material foreign object"),
  missingHole(9, "Missing hole");

  @override
  final int i;
  @override
  final String name;
  const TrackDefectClasses(this.i, this.name);

  static final Map<int, TrackDefectClasses> INT_TO_COMPONENT = Map.unmodifiable(
    Map.fromEntries(TrackDefectClasses.values.map((v) => MapEntry(v.i, v))),
  );
}
