import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/repositories/percentage_clients_model.dart';
import 'package:profair/src/shared/http_service.dart';

class ClientsRepository {
  final clientDio = HttpService();

  getClients(String? codeProvider, int accessTargenting, int merchandise, int? trading, int? groups) async {
    ResponseModel? response;

    print(accessTargenting);
    print(codeProvider);

    try {
      if (merchandise != 0 && trading != 0) {
        print("STEPPPPPPPPPPPPPPPPP 1");
        response = await clientDio.get("clientmerchandisetrading/$merchandise/$trading");
      } else if (accessTargenting == 3 && groups == 2) {
        print("STEP 6");
        response = await clientDio.get("groupspresentbygroup/$codeProvider");
      } else if (accessTargenting == 3 && groups == 1) {
        print("STEP 5");
        response = await clientDio.get("groupspresent");
      } else if (accessTargenting == 3) {
        print("STEPPPPPPPPPPPPPPPPP 2");
        response = await clientDio.get("stores");
      } else if (accessTargenting == 1 && codeProvider != null) {
        print("STEPPPPPPPPPPPPPPPPP 3");
        // response = await clientDio.get("storespresentbyprovider/$codeProvider");
        response = await clientDio.get("groupspresentbyprovider/$codeProvider");
      } else {
        print("STEPPPPPPPPPPPPPPPPP 4");
        response = await clientDio.get("storesbyprovider/$codeProvider");
      }
      List list = response.data as List;

      return list.map((json) => ClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  getPercentageProviders(int provider) async {
    ResponseModel? response;
    try {
      // response = await clientDio.get("percentageclients/$provider");
      response = await clientDio.get("percentagegroups/$provider");
      List list = response.data as List;

      return list.map((json) => PercentageClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
