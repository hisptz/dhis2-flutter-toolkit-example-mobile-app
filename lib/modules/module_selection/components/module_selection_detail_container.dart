import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';

class ModuleSelectionDetailContainer extends StatelessWidget {
  const ModuleSelectionDetailContainer(
      {super.key,
      required this.iconContainerSize,
      required this.appModule,
      this.disabled = false});

  final bool disabled;
  final double iconContainerSize;
  final AppModule appModule;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.4 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 8.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: iconContainerSize,
              width: iconContainerSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: appModule.color?.withOpacity(0.1),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 5.0,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.add_home_outlined,
                size: 40.0,
                color: appModule.color,
              ),
              // child: SvgPicture.asset(
              //   appModule.svgIcon ?? '',
              //   height: iconContainerSize * 0.7,
              //   width: iconContainerSize * 0.7,
              //   fit: BoxFit.scaleDown,
              // ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(),
                      child: Text(
                        '${appModule.title}',
                        style: const TextStyle().copyWith(
                          color: appModule.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: appModule.description!.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Text(
                          '${appModule.description}',
                          style: const TextStyle().copyWith(
                            color: const Color(0XFF1D2B36),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: appModule.countLabel!.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${appModule.countLabel}: ',
                                style: const TextStyle().copyWith(
                                  color: const Color(0XFF667685),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                ),
                              ),
                              TextSpan(
                                text: appModule.data?.totalCount != null
                                    ? appModule.data?.totalCount.toString()
                                    : 'N/A',
                                style: const TextStyle().copyWith(
                                  color: const Color(0XFF1D2B36),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
