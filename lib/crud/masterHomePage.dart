import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ngens/charts/vertical_fraction_bar.dart';
import 'package:ngens/layout/text_scale.dart';
import 'package:ngens/models/persistence.dart';
import 'package:ngens/models/root.dart';
import 'package:rapido/rapido.dart';
import 'package:ngens/models/organization.dart';
import 'package:ngens/models/user.dart';
import 'package:ngens/models/institute.dart';

import '../colors.dart';
import '../finance.dart';

class MasterHomePage extends StatefulWidget {
  final String title;

  const MasterHomePage({this.title});
  @override
  _MasterHomePageState createState() {
    _MasterHomePageState obj;
    var lables = Root.getLabels(title);
    switch (title) {
      case Root.organizaiton:
        obj = _MasterHomePageState<Organization>(lables);
        break;
      case Root.user:
        obj = _MasterHomePageState<User>(lables);
        break;
      case Root.institute:
        obj = _MasterHomePageState<Institute>(lables);
        break;
      default:
        obj = _MasterHomePageState<Organization>(lables);
    }
    return obj;
  }
}

class _MasterHomePageState<T extends Root<T>> extends State<MasterHomePage> {
  DocumentList documentList;

  _MasterHomePageState(Map<String, String> lables) {
    documentList = DocumentList(T.toString(),
        labels: lables, persistenceProvider: ModelPersistenceProvider<T>());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(
      documentList,
      formDecoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      emptyListWidget: const Center(
        child: Text('Click the add button to create your first task'),
      ),
      customItemBuilder: customItemBuilder,
    );
  }

  Widget customItemBuilder(int index, Document doc, BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Semantics.fromProperties(
      properties: const SemanticsProperties(
        button: true,
        enabled: true,
        label: '',
      ),
      excludeSemantics: true,
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 350),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, openContainer) =>
            FinancialEntityCategoryDetailsPage(),
        openColor: RallyColors.primaryBackground,
        closedColor: RallyColors.primaryBackground,
        closedElevation: 0,
        closedBuilder: (context, openContainer) {
          return TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: openContainer,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 32 + 60 * (cappedTextScale(context) - 1),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: VerticalFractionBar(
                          color: RallyColors.accountColor(0),
                          fraction: 1,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc['displayName'] as String,
                                  style: textTheme.bodyText2
                                      .copyWith(fontSize: 16),
                                ),
                                Text(
                                  (doc['lastUpdatedTime'] as Timestamp)
                                      .toDate()
                                      .toString(),
                                  style: textTheme.bodyText2
                                      .copyWith(color: RallyColors.gray60),
                                ),
                              ],
                            ),
                            Text(
                              doc['email'] as String,
                              style: textTheme.bodyText1.copyWith(
                                fontSize: 20,
                                color: RallyColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 32),
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        child:
                            const Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: RallyColors.dividerColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
