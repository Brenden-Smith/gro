import 'plant.dart';

class PlantEntry {
    Plant plant;
    String name;
    int daysToWater;
    DateTime dateCreated;

    PlantEntry({ this.plant });

    void setName(String n) {
      this.name = n;
    }

    void setDaysToWater(int n) {
      this.daysToWater = n;
    }

    void setDateCreated(DateTime d) {
      this.dateCreated = d;
    }

}