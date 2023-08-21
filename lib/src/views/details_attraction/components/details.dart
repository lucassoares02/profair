import 'package:flutter/material.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';

class ComponentDetails extends StatefulWidget {
  const ComponentDetails({super.key});

  @override
  State<ComponentDetails> createState() => _ComponentDetailsState();
}

class _ComponentDetailsState extends State<ComponentDetails> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderList(
          activeSearch: false,
          label: "Reunião",
        ),
        Container(
          padding: const EdgeInsets.all(appPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(appRadius)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    opacity: 0.8,
                    image: NetworkImage(
                      "https://images.pexels.com/photos/1855214/pexels-photo-1855214.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Reunião na sala Domingos Martins",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const AppSpacing(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorGrey),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Row(children: const [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: colorTertiary,
                      ),
                      SizedBox(width: 5),
                      Text("10:30")
                    ]),
                  ),
                ],
              ),
              const AppSpacing(),
              const Text(
                "É com grande entusiasmo que nos reunimos hoje nesta sala de eventos para discutir estratégias e oportunidades que nos permitirão trilhar um caminho de sucesso no futuro. Esta reunião representa um marco significativo em nossa jornada, pois nos dá a oportunidade de colaborar, compartilhar ideias e planejar ações que moldarão positivamente nosso crescimento e conquistas.",
                style: TextStyle(
                  color: colorGreyDark,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
              ),
              const AppSpacing(),
              Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: colorGreyLigth))),
                padding: const EdgeInsets.only(bottom: appMargin, top: 5),
              ),
              const AppSpacing(),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appMargin),
                decoration: BoxDecoration(
                  border: Border.all(color: colorGreyLigth),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(appRadius),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: colorGreyLigth))),
                      padding: const EdgeInsets.only(bottom: appMargin, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Teste de lyaout",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          )
                          // Text(
                          //   "Novo",
                          //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                          // ),
                        ],
                      ),
                    ),
                    const AppSpacing(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("10 de Janeiro de 2024", style: TextStyle(color: colorGrey, fontSize: 12)),
                        SizedBox(height: 10),
                        Text(
                          "Hoje é 10 de janeiro, estamos realizando teste desse layhout, parece que tudo está indo bem!",
                          style: TextStyle(fontSize: 12),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 20,
                          decoration: const BoxDecoration(border: Border(left: BorderSide(color: colorGreyLigth, width: 3))),
                          child: Text(
                            "sdf",
                            style: TextStyle(color: colorWhite),
                          ),
                        ),
                        Text("10 de Janeiro, 10:40", style: TextStyle(color: colorGrey, fontSize: 12)),
                        SizedBox(height: 10),
                        Text(
                          "Hoje é 10 de janeiro, estamos realizando teste desse layhout, parece que tudo está indo bem!",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
