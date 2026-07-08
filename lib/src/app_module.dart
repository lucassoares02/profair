import 'package:profair/src/views/clients/clients.dart';
import 'package:profair/src/views/clients_product/clients_product.dart';
import 'package:profair/src/views/consultants/consultants.dart';
import 'package:profair/src/views/customers/customers.dart';
import 'package:profair/src/views/details_attraction/details_attraction.dart';
import 'package:profair/src/views/details_balance/details_balance.dart';
import 'package:profair/src/views/details_notice/details_notice.dart';
import 'package:profair/src/views/details_provider.dart/details_provider.dart';
import 'package:profair/src/views/finish_trading/finish_trading_products.dart';
import 'package:profair/src/views/history_clients/history_clients.dart';
import 'package:profair/src/views/history_clients_tradings/history_clients_tradings.dart';
import 'package:profair/src/views/history_providers_by_clients/history_providers_by_clients.dart';
import 'package:profair/src/views/list_attractions/list_attractions.dart';
import 'package:profair/src/views/map/map_event_dynamic.dart';
import 'package:profair/src/views/notifications/notifications.dart';
import 'package:profair/src/views/order_details/order_details.dart';
import 'package:profair/src/views/preorder/preorder.dart';
import 'package:profair/src/views/products_provider/products_provider.dart';
import 'package:profair/src/views/providers/providers.dart';
import 'package:profair/src/views/providers_by_group/providers_by_group.dart';
import 'package:profair/src/views/negotiation_products/negotiation_products.dart';
import 'package:profair/src/views/reorder_tradings/reorder_tradings.dart';
import 'package:profair/src/views/reports/reports.dart';
import 'package:profair/src/views/requests_stores/requests_stores.dart';
import 'package:profair/src/views/select_negotiation/select_negotiation.dart';
import 'package:profair/src/views/select_negotiation_group/select_negotiation_group.dart';
import 'package:profair/src/views/select_store/select_store.dart';
import 'package:profair/src/views/ticket/ticket.dart';
import 'package:profair/src/views/trading_success/trading_sucess.dart';
import 'package:profair/src/views/tradings/tradings.dart';
import 'package:profair/src/views/tradings_provider/tradings_provider.dart';
import 'package:profair/src/views/tranding_products/trading_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:profair/src/views/search/search.dart';
import 'package:profair/src/views/splash/splash.dart';
import 'package:profair/src/views/login/login.dart';
import 'package:profair/src/views/home/home.dart';
import 'package:profair/src/views/app.dart';
import 'package:profair/src/views/tranding_products_history/trading_products_history.dart';
import 'package:profair/src/views/users/users.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/splash', child: (context, args) => const SplashPage()),
        ChildRoute('/app', child: (context, args) => const App()),
        ChildRoute('/login', child: (context, args) => const LoginPage()),
        ChildRoute('/home', child: (context, args) => const HomePage()),
        ChildRoute('/search', child: (context, args) => const Search()),
        ChildRoute('/listattractions', child: (context, args) => const ListAttractions()),
        ChildRoute(
          '/selectstore',
          child: (context, args) => SelectStore(
            client: args.data["client"],
            codeConsult: args.data["consult"],
            codeProvider: args.data["codeProvider"],
          ),
        ),
        ChildRoute('/preorder', child: (context, args) => PreOrder(homeController: args.data)),
        ChildRoute('/listrequestsstores',
            child: (context, args) => RequestsStores(
                  codeProvider: args.data["codeProvider"],
                  userCode: args.data["userCode"],
                  visibleBuyers: args.data["visibleBuyers"],
                  codeNegotiation: args.data["codeNegotiation"],
                  homeController: args.data["homeController"],
                )),
        ChildRoute('/listrequestsstorenegotiation',
            child: (context, args) => DetailsBalance(
                  codeProvider: args.data["codeProvider"],
                  userCode: args.data["userCode"],
                )),
        ChildRoute(
          '/productsprovider',
          child: (context, args) => ProductsProvider(
            codeProvider: args.data["codeProvider"],
            codeClient: args.data["codeClient"],
            nextScreen: args.data["nextScreen"],
          ),
        ),
        ChildRoute(
          '/orderdetails',
          child: (context, args) => OrderDetails(
            order: args.data["order"],
          ),
        ),
        ChildRoute(
          '/clients',
          child: (context, args) => Clients(
            trading: args.data["codeTrading"],
            merchandise: args.data["merchandise"],
            codeProvider: args.data["codeProvider"],
            accessTargenting: args.data["accessTargenting"],
            groups: args.data["groups"],
          ),
        ),
        ChildRoute(
          '/selectprovider',
          child: (context, args) => Providers(
            codeClient: args.data["codeClient"],
            codeBranch: args.data["codeBranch"],
            codeBuyer: args.data["codeBuyer"],
          ),
        ),
        ChildRoute('/users', child: (context, args) => const Users()),
        ChildRoute('/customers',
            child: (context, args) => Customers(
                  homeController: args.data,
                )),
        ChildRoute(
          '/detailsprovider',
          child: (context, args) => DetailsProvider(
            codeBranch: args.data["codeBranch"],
            codeProvider: args.data["codeProvider"],
            imageProvider: args.data["imageProvider"],
            nameProvider: args.data["nameProvider"],
            color: args.data["color"],
          ),
        ),
        ChildRoute(
          '/providerbygroup',
          child: (context, args) => ProvidersByGroup(
            codeClient: args.data["codeClient"],
          ),
        ),
        ChildRoute(
          '/tradingsuccess',
          child: (context, args) => TradingSucess(
              client: args.data["client"],
              consult: args.data["consult"],
              clientModel: args.data["clientModel"],
              trading: args.data["trading"],
              provider: args.data["provider"],
              branch: args.data["branch"],
              hour: args.data["hour"],
              value: args.data["value"],
              finishTradingController: args.data["finishTradingController"]),
        ),
        ChildRoute('/tradings',
            child: (context, args) => Tradings(
                  homeController: args.data,
                )),
        ChildRoute('/reordertradings',
            child: (context, args) => ReorderTradings(
                  homeController: args.data,
                )),
        ChildRoute('/negotiationproducts',
            child: (context, args) => NegotiationProducts(
                  codeProvider: args.data["codeProvider"],
                  codeTrading: args.data["codeTrading"],
                  title: args.data["title"],
                )),
        ChildRoute('/clientsproduct', child: (context, args) => ClientsProducts(product: args.data)),
        ChildRoute('/reports', child: (context, args) => Reports(codeProvider: args.data["codeProvider"], accessTargeting: args.data["accessTargeting"])),

        // ChildRoute(
        //   '/selectnegotiation',
        //   child: (context, args) => SelectNegotiation(
        //       codeBranch: args.data["codeBranch"],
        //       nameBranch: args.data["nameBranch"],
        //       codeClient: args.data["codeClient"],
        //       codeProvider: args.data["codeProvider"],
        //       listBranchs: args.data["listBranchs"],
        //       codeConsult: args.data["consult"],
        //       balance: args.data["balance"]),
        // ),
        ChildRoute('/selectnegotiation', child: (context, args) {
          return args.data["new"] != null
              ? TradingsProvider(
                  codeBranch: args.data["codeBranch"],
                  nameBranch: args.data["nameBranch"],
                  codeClient: args.data["codeClient"],
                  codeProvider: args.data["codeProvider"],
                  listBranchs: args.data["listBranchs"],
                  codeConsult: args.data["consult"],
                  client: args.data["client"],
                  balance: args.data["balance"])
              : SelectNegotiation(
                  codeBranch: args.data["codeBranch"],
                  nameBranch: args.data["nameBranch"],
                  codeClient: args.data["codeClient"],
                  codeProvider: args.data["codeProvider"],
                  listBranchs: args.data["listBranchs"],
                  codeConsult: args.data["consult"],
                  balance: args.data["balance"]);
        }),
        ChildRoute(
          '/tradingproducts',
          child: (context, args) => TradingProducts(
            codeBranch: args.data["codeBranch"],
            nameBranch: args.data["nameBranch"],
            codeProvider: args.data["codeProvider"],
            codeClient: args.data["codeClient"],
            codeTrading: args.data["codeTrading"],
            tradings: args.data["tradings"],
            codeConsult: args.data["codeConsult"],
            listBranchs: args.data["listBranchs"],
          ),
        ),

        ChildRoute(
          '/selectnegotiationgroup',
          child: (context, args) => SelectNegotiationGroup(
              codeGroup: args.data["codeGroup"],
              nameBranch: args.data["nameBranch"],
              codeClient: args.data["codeClient"],
              codeProvider: args.data["codeProvider"],
              listBranchs: args.data["listBranchs"],
              codeConsult: args.data["consult"],
              balance: args.data["balance"]),
        ),
        ChildRoute(
          '/finishtrading',
          child: (context, args) => FinishTrading(
            codeBranch: args.data["codeBranch"],
            nameBranch: args.data["nameBranch"],
            codeProvider: args.data["codeProvider"],
            codeTrading: args.data["codeTrading"],
            codeClient: args.data["codeClient"],
            productsTrading: args.data["productsTrading"],
            tradings: args.data["tradings"],
            listBranchs: args.data["listBranchs"],
            codeConsult: args.data["codeConsult"],
            initialListProducts: args.data["initialListProducts"],
          ),
        ),
        ChildRoute(
          '/detailsattraction',
          child: (context, args) => DetailsAttractions(
            id: args.data["id"],
          ),
        ),
        ChildRoute(
          '/detailsnotice',
          child: (context, args) => DetailsNotice(
            id: args.data["id"],
            codeBranch: args.data["codeBranch"],
            accessTargeting: args.data["accessTargeting"],
          ),
        ),
        // ChildRoute(
        //   '/ticket',
        //   child: (context, args) => MapEventDynamic(),
        // ),
        ChildRoute(
          '/ticket',
          child: (context, args) => Ticket(
            homeController: args.data,
          ),
        ),
        ChildRoute('/mapevent',
            child: (context, args) => MapEventDynamic(
                  map: args.data["map"],
                )),
        ChildRoute(
          '/notifications',
          child: (context, args) => Notifications(
            notificationsPeding: args.data, // Pass the notifications pending list
          ),
        ),
        ChildRoute(
          '/history-clients',
          child: (context, args) => HistoryClients(
            provider: args.data["codeProvider"],
          ),
        ),
        ChildRoute(
          '/history-clients-tradings',
          child: (context, args) => HistoryClientsTradings(
            provider: args.data["provider"],
            client: args.data["client"],
          ),
        ),
        ChildRoute(
          '/history-providers-by-clients',
          child: (context, args) => HistoryProvidersByClients(
            client: args.data["client"],
            isProvider: args.data["isProvider"],
          ),
        ),
        ChildRoute(
          '/tradingproductshistory',
          child: (context, args) => TradingProductsHistory(
            codeBranch: args.data["codeBranch"],
            codeProvider: args.data["codeProvider"],
            codeTrading: args.data["codeTrading"],
            comprador: args.data["comprador"],
            vendedor: args.data["vendedor"],
            date: args.data["date"],
          ),
        ),
        ChildRoute(
          '/consultants',
          child: (context, args) => Consultants(
            provider: args.data["provider"],
          ),
        ),
      ];

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
