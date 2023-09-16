import 'package:profair/src/views/clients/clients.dart';
import 'package:profair/src/views/clients_product/clients_product.dart';
import 'package:profair/src/views/details_attraction/details_attraction.dart';
import 'package:profair/src/views/details_provider.dart/details_provider.dart';
import 'package:profair/src/views/details_recipe/details_recipe.dart';
import 'package:profair/src/views/finish_trading/finish_trading_products.dart';
import 'package:profair/src/views/list_attractions/list_attractions.dart';
import 'package:profair/src/views/list_category/list_category.dart';
import 'package:profair/src/views/create_post/create_post.dart';
import 'package:profair/src/views/list_recipe/list_recipe.dart';
import 'package:profair/src/views/favorites/favorites.dart';
import 'package:profair/src/views/preorder/preorder.dart';
import 'package:profair/src/views/products_provider/products_provider.dart';
import 'package:profair/src/views/profile/profile.dart';
import 'package:profair/src/views/providers/providers.dart';
import 'package:profair/src/views/providers_by_group/providers_by_group.dart';
import 'package:profair/src/views/reports/reports.dart';
import 'package:profair/src/views/requests_stores/requests_stores.dart';
import 'package:profair/src/views/select_negotiation/select_negotiation.dart';
import 'package:profair/src/views/select_store/select_store.dart';
import 'package:profair/src/views/ticket/ticket.dart';
import 'package:profair/src/views/tradings/tradings.dart';
import 'package:profair/src/views/tranding_products/trading_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:profair/src/views/search/search.dart';
import 'package:profair/src/views/splash/splash.dart';
import 'package:profair/src/views/login/login.dart';
import 'package:profair/src/views/home/home.dart';
import 'package:profair/src/views/app.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/splash', child: (context, args) => const SplashPage()),
        ChildRoute('/app', child: (context, args) => const App()),
        ChildRoute('/login', child: (context, args) => const LoginPage()),
        ChildRoute('/home', child: (context, args) => const HomePage()),
        ChildRoute('/favorites', child: (context, args) => const Favorites()),
        ChildRoute('/create', child: (context, args) => const CreatePost()),
        ChildRoute('/search', child: (context, args) => const Search()),
        ChildRoute('/profile', child: (context, args) => const Profile()),
        ChildRoute('/detailsrecipe', child: (context, args) => DetailsRecipe(recipe: args.data)),
        ChildRoute('/listattractions', child: (context, args) => const ListAttractions()),
        ChildRoute('/selectstore', child: (context, args) => SelectStore(client: args.data["client"], codeProvider: args.data["codeProvider"])),
        ChildRoute('/listrecipe', child: (context, args) => ListRecipe(recipe: args.data)),
        ChildRoute('/listcategory', child: (context, args) => ListCategory(category: args.data)),
        ChildRoute('/preorder', child: (context, args) => PreOrder(homeController: args.data)),
        ChildRoute('/listrequestsstores',
            child: (context, args) => RequestsStores(
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
        ChildRoute('/clients',
            child: (context, args) => Clients(
                trading: args.data["codeTrading"],
                merchandise: args.data["merchandise"],
                codeProvider: args.data["codeProvider"],
                accessTargenting: args.data["accessTargenting"])),
        ChildRoute(
          '/selectprovider',
          child: (context, args) => Providers(
            codeClient: args.data["codeClient"],
            codeBranch: args.data["codeBranch"],
            codeBuyer: args.data["codeBuyer"],
          ),
        ),
        ChildRoute(
          '/detailsprovider',
          child: (context, args) => DetailsProvider(
            codeBranch: args.data["codeBranch"],
            codeProvider: args.data["codeProvider"],
          ),
        ),
        ChildRoute(
          '/providerbygroup',
          child: (context, args) => ProvidersByGroup(
            codeClient: args.data["codeClient"],
          ),
        ),
        ChildRoute('/tradings', child: (context, args) => Tradings(codeProvider: args.data)),
        ChildRoute('/clientsproduct', child: (context, args) => ClientsProducts(codeProduct: args.data)),
        ChildRoute('/reports', child: (context, args) => Reports(codeProvider: args.data["codeProvider"], accessTargeting: args.data["accessTargeting"])),
        ChildRoute(
          '/selectnegotiation',
          child: (context, args) => SelectNegotiation(
            codeBranch: args.data["codeBranch"],
            nameBranch: args.data["nameBranch"],
            codeClient: args.data["codeClient"],
            codeProvider: args.data["codeProvider"],
            listBranchs: args.data["listBranchs"],
          ),
        ),
        ChildRoute(
          '/tradingproducts',
          child: (context, args) => TradingProducts(
            codeBranch: args.data["codeBranch"],
            nameBranch: args.data["nameBranch"],
            codeProvider: args.data["codeProvider"],
            codeClient: args.data["codeClient"],
            codeTrading: args.data["codeTrading"],
            tradings: args.data["tradings"],
            listBranchs: args.data["listBranchs"],
          ),
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
          ),
        ),
        ChildRoute(
          '/detailsattraction',
          child: (context, args) => DetailsAttractions(
            title: args.data["title"],
            content: args.data["content"],
            hour: args.data["hour"],
            image: args.data["image"],
          ),
        ),
        ChildRoute(
          '/ticket',
          child: (context, args) => Ticket(
            homeController: args.data,
          ),
        ),
      ];

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
