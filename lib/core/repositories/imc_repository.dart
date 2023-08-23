
import 'package:imc_att/core/models/imc.dart';

class ImcRepository {
  List<Imc> _imcList = [];

  void addImc(Imc imc){
    _imcList.add(imc);
  }

  List<Imc> getImc(){
    return _imcList;
  }
}