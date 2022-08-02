import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:dolfin_flutter/bloc/onboarding/onboarding_cubit.dart';
import 'package:dolfin_flutter/presentation/widgets/circular_button.dart';
import 'package:dolfin_flutter/presentation/widgets/custom_dots.dart';
import 'package:dolfin_flutter/presentation/widgets/mybutton.dart';
import 'package:dolfin_flutter/presentation/widgets/mycustompainter.dart';
import 'package:dolfin_flutter/presentation/widgets/onboarding_item.dart';
import 'package:dolfin_flutter/shared/constants/consts_variables.dart';
import 'package:dolfin_flutter/shared/constants/strings.dart';
import 'package:dolfin_flutter/shared/styles/colours.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.dark_blue,
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {},
        builder: (context, state) {
          OnboardingCubit cubit = BlocProvider.of(context);
          return SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
              _buildAppBar(context),
              SizedBox(
                height: 1.h,
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                      width: 100.w,
                      height: 86.h,
                      color: AppColours.dark_blue,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn);

                                    cubit.curruntindext > 0
                                        ? cubit.removefromindex()
                                        : null;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      'Back',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(
                                            fontSize: 13.sp,
                                            color: cubit.curruntindext != 0
                                                ? AppColours.white
                                                : AppColours.dark_blue,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                CustomDots(myindex: cubit.curruntindext),
                                SizedBox(
                                  width: 10.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _pageController.animateToPage(
                                        onboardinglist.length - 1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeOut);
                                    cubit.curruntindext <
                                            onboardinglist.length - 1
                                        ? cubit.skipindex()
                                        : null;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      'Skip',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(
                                            fontSize: 13.sp,
                                            color: cubit.curruntindext !=
                                                    onboardinglist.length - 1
                                                ? AppColours.white
                                                : AppColours.dark_blue,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 100.w,
                    height: 81.h,
                    child: CustomPaint(
                      painter: const MycustomPainter(color: AppColours.white),
                      child: SizedBox(
                        width: 80.w,
                        height: 43.h,
                        child: PageView.builder(
                          itemCount: onboardinglist.length,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          itemBuilder: ((context, index) {
                            return OnBoardingItem(
                              index: index,
                              image: onboardinglist[index].img,
                              title: onboardinglist[index].title,
                              description: onboardinglist[index].description,
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    child: CircularButton(
                        color: AppColours.light_blue,
                        width: 30.w,
                        icon: Icons.arrow_right_alt_sharp,
                        condition:
                            cubit.curruntindext != onboardinglist.length - 1,
                        func: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          if (cubit.curruntindext < onboardinglist.length - 1) {
                            cubit.changeindex();
                          } else {
                            cubit
                                .getpref('seen')
                                .then((seen) => _loadNextPage(seen));
                          }
                        }),
                  ),
                ],
              ),
            ],
          ));
        },
      ),
    );
  }

  Row _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            size: 30.sp,
          ),
        ),
        Text(
          '',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox()
      ],
    );
  }

  void _loadNextPage(bool? seen) {
    OnboardingCubit cubit = BlocProvider.of(context);
    if (seen != null && seen) {
      Navigator.pop(context);
      cubit.curruntindext = 0;
    } else {
      Navigator.pushReplacementNamed(context, welcomepage);
      cubit.savepref('seen');
    }
  }
}
