
import 'dart:io';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Screens/dashboard_tiles.dart';
import 'package:flutter_quiz_app/Widgets/constants.dart';
import 'package:flutter_quiz_app/model/request_model/logout_user_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:flutter_quiz_app/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../utill/userConstants.dart';

class TreeScreen extends StatefulWidget {
   TreeScreen(this.isAnimation,{Key? key}) : super(key: key);

  bool isAnimation;

  @override
  // ignore: library_private_types_in_public_api
  _TreeScreenState createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> with TickerProviderStateMixin{

  late AnimationController controllerBlink;
  late AnimationController controllerForward;

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  bool _isLoading2 = true;
  late int countNumber;
  int countNumber2 = -1;
  bool _showFirstImage = true;
  String errorMessage = "";
  // ignore: prefer_typing_uninitialized_variables
  late final _random;
  // ignore: prefer_typing_uninitialized_variables
  var element;
  String url = "";
  late bool isPhone;
  bool showTapHereButton = false;

  bool get isForwardAnimation =>
      controllerForward.status == AnimationStatus.forward ||
          controllerForward.status == AnimationStatus.completed;

  // bool get isReversAnimation =>
  //     controllerReverse.status == AnimationStatus.reverse ||
  //         controllerReverse.status == AnimationStatus.completed;




  List quoteList = <String> [
    "What some intended for evil, God intended for good",
    "A person of wisdom and understanding maintains balance and order",
    "A prudent man sees danger and takes refuge but the simple keep on going and suffer",
    "Consider what a great forest is set on fire by a small spark. The tongue also is a fire…",
    "You cannot heal what isn’t real, or true",
    "A cheerful heart is good medicine, but a crushed spirit dries up the bones",
    "A generous person will prosper, he who refreshes others will himself be refreshed",
    "A person of wisdom and understanding maintains balance and order",
    "A prudent man sees danger and takes refuge, but the simple keep on going and suffer for it",
    "All life is an experiment. The more experiments you make the better",
    "Anyone who stops learning is old, whether at twenty or eighty. Anyone who keeps learning stays young",
    "As irons sharpens iron, so one man sharpens another",
    "Ask and it will be given, seek and you shall find, knock and the door will be opened",
    "Be quick to listen, slow to speak, and slow to be angry",
    "Be transformed by the renewing of your mind",
    "Be yourself; everyone else is already taken",
    "Beneath the clothes we find a man, and beneath the man we find his nucleus",
    "Change is the law of life. And those who look only to the past or present are certain to miss the future",
    "Conceal a flaw, and the world will imagine the worst",
    "Consider it pure joy, when you face trials of many kinds, because the testing of your faith produces perseverance. Let perseverance, finish its work so that you may be mature and complete, not lacking anything",
    "Discovering the truth about ourselves is a lifetime's work, but it's worth the effort",
    "Do I need to be liked? Absolutely not. I like to be liked. I enjoy being liked. I have to be liked. But it’s not like, this compulsive need to be liked, like my need to be praised",
    "Do not worry about tomorrow for tomorrow will worry about itself. Each day has enough trouble of its own",
    "Do, or do not, there is no try",
    "Does the brain control you or are you controlling the brain? I don't know if I'm in charge of mine",
    "Don't you want a little taste of the glory, and see what it tastes like?!",
    "Each life is made up of mistakes and learning, waiting and growing, practicing patience and being persistent",
    "Empathy is a superpower",
    "Even a small child is know by their actions",
    "Every person's happiness is his own responsibility",
    "Extravagance is its own destroyer",
    "Fear leads to anger, anger leads to hate, hate leads to suffering",
    "Feeling empowered always leads to creativity and connectivity giving life to all",
    "Folks are sally about as happy as they make up their minds to be",
    "Forgiveness is not an occasional act: it is a permanent attitude"
    "Forgiving isn't something you do for someone else. It's something you do for yourself",
    "Get that corn out of my face!",
    "Give yourself a gift, the present moment",
    "Hang on to your youthful enthusiasms, you will be able to use them better when you are older",
    "Happiness Isn’t Found in Things, but in Virtue Alone – It’s All About What We Value and the Choices We Make",
    "Watered stirs up conflict, but love conquers over all wrongs",
    "He who refreshes others, will himself be refreshed",
    "How can you say to your brother, 'let me take the speck out of your eye' when all the time there is a plank in your own eye. First, take the plank out of your own eye, and then you will see clearly to take the speck out of your brother's eye",
    "How many times have you noticed that it's the little quiet moments in the midst of life that seem to give the rest extra-special meaning?",
    "I am about to do something very bold in this job that I’ve never done before: try",
    "I consider myself a good person...but I'm gonna try to make him cry",
    "I do not think much of a man who is not wiser today than he was yesterday",
    "I don’t hate it. I just don’t like it at all. And it’s terrible",
    "I hope you're proud of yourself for the times you've said 'yes,' when all it meant was extra work for you and was seemingly helpful only to somebody else",
    "I knew exactly what to do. But in a much more real sense, I had no idea what to do",
    "I love inside jokes. I’d love to be a part of one someday",
    "I miss the days when there was only one party I didn't want to go to",
    "I only know that I know nothing",
    "I wish there was a way to know you're in the good old days before you've actually left them",
    "I’m an early bird and I’m a night owl. So I’m wise, and I have worms",
    "I’ve been involved in a number of cults, both a leader and a follower. You have more fun as a follower, but you make more money as a leader",
    "If I don't have some cake soon, I might die",
    "If you could only sense how important you are to the lives of those you meet; how important you can be to the people you may never even dream of. There is something of yourself that you leave at every meeting with another person",
    "If you don't design your own life plan, chances are you'll fall into someone else's plan. And guess what they have planned for you? Not much",
    "If you wake up you have purpose",
    "I'm not superstitious...but I'm a little seditious",
    "Imagine what our real neighborhoods would be like if each of us offered, as a matter of course, just one kind word to another person",
    "In a way, you’ve already won in this world because you’re the only one who can be you",
    "It is a rough road that leads to the heights of greatness",
    "It is more civilized to make fun of life than to bewail it",
    "It is not good to have zeal without knowledge or to be hasty and miss the way"
    "It is the nature of the wise to resist pleasures, but the foolish to be a slave to them",
    "It’s better to know how to learn than learn how to know",
    "It’s not about what it is it’s about what it can become",
    "It’s not so much what we have in this life that matters. It’s what we do with what we have",
    "I've failed over and over and over again in my life and that is why I succeed",
    "Knowing that we can be loved exactly as we are gives us all the best opportunity for growing into the healthiest of people",
    "Leadership is about vision, seeing what’s needed or missing, and helping people act",
    "Learn to grieve well, then do it do it regularly",
    "Let another praise you and not your own lips"
    "Let no man pull you low enough to hate him",
    "Life is a daring adventure or nothing at all",
    "Life is not a problem to be solved, but a reality to be experienced",
    "Life is ten percent what happens to you and ninety percent how you respond to it",
    "Life is very short and anxious for those who forget the past, neglect the present, and fear the future",
    "Listening is where love begins: listening to ourselves and then to our neighbors",
    "Little by little we human beings are confronted with situations that give us more and more clues that we are not perfect. "
    "Love and success, always in that order. It's that simple AND that difficult",
    "Love is like infinity: You can't have more or less infinity, and you can't compare two things to see if they're 'equally infinite.' Infinity just is, and that's the way I think love is, too",
    "Man conquers the world by conquering himself",
    "Many of life's failures are people who did not realize how close they were to success when they gave up",
    "Me think, why waste time say lot word, when few word do trick?"
    "Most people want to avoid pain, and discipline is usually painful",
    "My mission in life is not merely to survive, but to thrive; and to do so with some passion, some compassion, some humor, and some style",
    "No Man Is an Island",
    "No man is free who is not master of himself",
    "Not all heroes where capes",
    "Often out of periods of losing come the greatest strings toward a new winning streak",
    "One of the problems with being a rescuer is we inevitably become the persecutor",
    "One of the problems with being a victim is we inevitably become the persecutor",
    "Only time can heal what reason cannot",
    "Our Personal Development is Bound Up in Cooperation with Others",
    "People are prisoners of their phone. That's why they call it a cell phone",
    "People grow through experience if they meet life honestly and courageously. This is how character is built",
    "Persist and Resist: It’s All about Progress, Not Perfection",
    "Raise up a child in the way that they should go and when they are old they will not depart",
    "Rise up this matter is in your hands. We will support you, so take courage and do it",
    "Sometimes I get so bored, I just want to scream. And then sometimes, I actually do scream. I just sort of feel out what the situation calls for",
    "Sometimes I'll start a sentence and I don't even know where it's going. I just hope I find it along the way. Like an improv conversation",
    "Sometimes the questions are complicated and the answers are simple",
    "Sometimes we must let go of our pride and do what is requested of us",
    "Sometimes you will never know the value of a moment, until it becomes a memory",
    "your sensibilities, so that life shall hurt you as little as possible",
    "Step with care and great tact. And remember that life’s a great balancing act",
    "Summon your eagle powers",
    "That some achieve great success is proof to others that all can achieve it",
    "The best answer to anger is silence",
    "The better part of one's life consists of his friendships",
    "The future doesn't belong to the light-hearted, it belongs to the brave",
    "The glory of God is to conceal a matter. The glory of a king is to search a matter out",
    "The greatest day in your life and mine is when we take total responsibility for our attitudes. That's the day we truly grow up",
    "The greatest gift you ever give is your honest self",
    "The more we value things outside our control, the less control we have",
    "The most difficult thing is the decision to act, the rest is merely tenacity. The fears are paper tigers. You can do anything you decide to do. You can act to change and control your life; and the procedure, the process is its own reward",
    "The only thing evil can't stand is forgiveness",
    "The purposes of a person's heart are deep waters, but a person of wisdom and understanding draws them out",
    "The ultimate value of life depends upon awareness and the power of contemplation rather than upon mere survival",
    "The way of fools, but a wise man seeks council",
    "There are no bad pictures; that’s just how your face looks sometimes",
    "There are times when explanations, no matter how reasonable, just don't seem to help",
    "There is a time and a season for everything under the sun",
    "There is a way that seems right, but in the end it leads to death",
    "There is always a bigger fish",
    "There is no limit to the amount of good you can do, if you don’t care who gets the credit",
    "There is no love without forgiveness, and there is no forgiveness without love. If we really want to love, we must learn how to forgive",
    "There is no normal life that is free of pain. It's the very wrestling with our problems that can be the impetus for our growth",
    "There is no passion to be found playing small--in settling for a life that is less than the one you are capable of living",
    "There's a world of difference between insisting on someone's doing something and establishing an atmosphere in which that person can grow into wanting to do it",
    "These are my recreational clothes",
    "Those who look for the bad in people will surely find it",
    "To love someone is to strive to accept that person exactly the way he or she is, right here and now",
    "To the world you may be one person; but to one person you may be the world",
    "I shall behave, as if this is the day I will be remembered",
    "Too often we underestimate the power of a touch, a smile, a kind word, a listening ear, an honest compliment, or the smallest act of caring, all of which have the potential to turn a life around",
    "Train a child in the way that they should go and when they are old they will not depart",
    "Transformation is a process, and as life happens there are tons of ups and downs. It's a journey of discovery--there are moments on mountaintops and moments in deep valleys of despair",
    "We Are and Must Remain a Unified Self – We Can’t Complain or Blame Anyone Else",
    "Rufus We begin to lose our hesitation to do immoral things when we lose our hesitation to speak of them",
    "We Don’t Control External Events, We Only Control Our Thoughts, Opinions, Decisions and Duties",
    "We have always held to the hope, the belief, the conviction that there is a better life, a better world, beyond the horizon",
    "We make a living by what we get, but we make a life by what we give",
    "We must all suffer one of two things: the pain of discipline or the pain of regret or disappointment",
    "We often want mercy for ourselves but justice for others",
    "We speak with more than our mouths. We listen with more than our ears",
    "We suffer more often in imagination than in reality",
    "We’ve Each Been Given All the Inner Resources We Need to Thrive",
    "What some intended for evil, God intended for good",
    "When I was a child, I talked like a child, I thought like a child, and reasoned like a child, when I became an adult, I put childish ways behind me",
    "When life is too easy for us, we must beware or we may not be ready to meet the blows which sooner or later come to everyone, rich or poor",
    "When we can talk about our feelings, they become less overwhelming, less upsetting and less scary",
    "When you arise in the morning, think of what a precious privilege it is to be alive – to breathe, to think, to enjoy, to love",
    "Whenever I'm about to do something, I think, 'Would an idiot do that?' and if they would, I do not do that thing",
    "Who says exactly what they’re thinking? What kind of a game is that?",
    "Whoever loves discipline loves knowledge",
    "Why fit in when you were born to stand out?",
    "Would I rather be feared or loved? Easy. Both. I want people to be afraid of how much they love me",
    "You can't really love someone else unless you really love yourself first",
    "You can't stop change any more than you can stop the sun from setting",
    "You have brains in your head. You have feet in your shoes. You can steer yourself in any direction you choose",
    "You only live once, but if you do it right, once is enough",
    "You shall know the truth and the truth shall set you free",
    "You’ll miss the best things if you keep your eyes shut",
    "A house divided against itself cannot stand",
    "A rich man is nothing but a poor man with money",
    "And I feel God in this Chili’s tonight",
    "Be sure you put your feet in the right place, then stand firm",
    "Eggs are fantastic for a fitness diet. If you don’t like the taste, just add cocoa, flour, sugar, butter, baking powder and cook at 350 for 30 minutes",
    "Even if you’re on the right track, you’ll get run over if you just sit there",
    "Everyone makes mistakes, so why can’t you?",
    "Fool me once, strike one. But fool me twice...strike three",
    "Give me six hours to chop down a tree and I will spend the first four sharpening the axe",
    "I am a black belt in gift wrapping",
    "I am not bound to win, but I am bound to be true. I am not bound to succeed, but I am bound to live up to what light I have",
    "I am not concerned that you have fallen — I am concerned that you arise",
    "I don’t like that man. I must get to know him better",
    "I have been trying to get on jury duty every year since I was 18 years old. To get to go sit in an air-conditioned room, downtown, judging people, while my lunch is paid for… that is the life",
    "I love being married. It’s so great to find that one special person you want to annoy for the rest of your life",
    "I wanna do a cartwheel. But real casual-like. Not enough to make a big deal out of it, but I know everyone saw it. Just one stunning, gorgeous cartwheel",
    "I will prepare and someday my chance will come",
    "I’m a success today because I had a friend who believed in me and I did’t have the heart to let him down",
    "If you are neutral in situations of injustice you have chosen the side of the oppressor",
    "If you think you are too small to make a difference, try sleeping with a mosquito",
    "Imagine what our neighborhoods would be like if each of us offered, as a matter of course, just one kind word to another person",
    "It is not the critic who counts...the credit belongs to the man who is actually in the arena, whose face is marred by dust and sweat and blood; who strives valiantly; who errs...who knows great enthusiasms, the great devotions; who spends himself in a worthy cause..",
    "It’s our job to encourage each other to discover that uniqueness and to provide ways of developing its expression",
    "Love and trust, in the space between what’s said and what’s heard in our life, can make all the difference in this world",
    "My favorite machine at the gym is the vending machine",
    "Nearly all men can stand adversity, but if you want to test a man’s character, give him power",
    "Nothing in the world is more dangerous than sincere ignorance and conscientious stupidity",
    "PowerPoints are the peacocks of the business world; all show, no meat",
    "Some people have a way with words, and other people...oh, uh, not have way",
    "The best way to predict your future is to create it",
    "The cure for boredom is curiosity. There is no cure for curiosity",
    "The philosophy of the school room in one generation will be the philosophy of government in the next",
    "We live in a world in which we need to share responsibility. It’s easy to say ‘It’s not my child, not my community, not my world, not my problem.’ Then there are those who see the need and respond. I consider those people my heroes",
    "What we think, or what we know, or what we believe is, in the end, of little consequence. The only consequence is what we do",
    "Whatever you are, be a good one",
    "Who we are in the present includes who we were in the past",
    "Worrying is like paying a debt you don’t owe",
    "Yes, I have a dream, and it’s not some MLK dream for equality. I want to own a decommissioned lighthouse. And I want to live at the top. And nobody knows I live there. And there’s a button that I can press, and launch that lighthouse into space",
    "You’d be a grouch, too, if you lived in a trash can!",
    "And who knows but that you have come to your elevated position of influence for such a time as this",
    "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away",
  ];

  @override
  void initState() {

    _random = Random();
    element = quoteList[_random.nextInt(quoteList.length)];
    _getUserData();
    controllerBlink = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // controllerForward = AnimationController(
    //   value: 1,
    //   duration: Duration(milliseconds: 2000),
    //   reverseDuration: Duration(milliseconds: 2000),
    //   vsync: this,
    // )..addStatusListener((status) => setState(() {}));

    controllerForward = AnimationController(
      value: 1,
      duration:const Duration(milliseconds: 3000),
      reverseDuration:const Duration(milliseconds: 3000),
      vsync: this,
    )..addStatusListener((status) => setState(() {}));

    // _getAnswerData();

    super.initState();
  }

  getScreenDetails() {
    setState(() {
      _isLoading = true;
    });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
   // controllerReverse.dispose();
    controllerForward.dispose();
    controllerBlink.dispose();
    super.dispose();
  }


  void _changeImage(int count) {
    // print("COUNT NUMBER");
    // print(count);

    if(count == 0) {
      setState(() {
        countNumber = 1;
        controllerForward.forward();
      });
      // print(countNumber);
      if(!isPhone) {
        url = "assets/apple_tree/apple_ipad/$countNumber.png";
      } else {
        url = "assets/apple_tree/apple_mobile/$countNumber.png";
      }
      // print(url);
    } else {
      setState(() {
        controllerForward.reverse();
        if (_showFirstImage) {
          countNumber = count - 1;
        } else {
          countNumber = count;
        }
        // print(countNumber);
        if(!isPhone) {
          url = "assets/apple_tree/apple_ipad/$countNumber.png";
        } else {
          url = "assets/apple_tree/apple_mobile/$countNumber.png";
        }
        // print(url);
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Future.delayed(const Duration(seconds: 5)).then((value) {

            setState(() {
              showTapHereButton = true;
            });
          });
          setState(() {
            _showFirstImage = false;
            if (_showFirstImage) {
              countNumber = count - 1;
            } else {
              countNumber = count;
            }
            //print(countNumber);
            if(!isPhone) {
              url = "assets/apple_tree/apple_ipad/$countNumber.png";
            } else {
              url = "assets/apple_tree/apple_mobile/$countNumber.png";
            }
            //print(url);
            controllerForward.forward();
          });
        });
      });
    }
  }

  _getTreeGrowth() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("Score", "");
      _isLoading = true;
      _isLoading2 = true;
    });

    HTTPManager().treeGrowth(LogoutRequestModel(userId: id)).then((value)  {



      int count = value["response_count"];
     // countNumber = value["response_count"];

      setState(() {
        sharedPreferences.setString("Score", count.toString());
        countNumber2 = count;
      });

     //  if(count == 0) {
     //    countNumber = 0;
     // //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
     //  } else {
        _changeImage(count);
      //}
      setState(() {
        errorMessage = "";
        _isLoading = false;
        _isLoading2 = false;
      });
    //  showToastMessage(context, value['message'].toString(),true);
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _isLoading2 = false;
        errorMessage = e.toString();
      });
      showToastMessage(context, e.toString(),false);
    });

  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    // print("Data getting called");
    // print(name);
    // print(id);
    _getTreeGrowth();
    setState(() {
      _isUserDataLoading = false;
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()),
            (Route<dynamic> route) => false
    );
    // int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 11);
    return true;
  }


  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) =>const SplashScreen()),
                      (Route<dynamic> route) => false
              );
            },
          ),
          title: Text(_isUserDataLoading ? "" : name),
          actions:  [
            PopMenuButton(false,false,id)
          ],
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Dashboard()));
              },
              child: _isLoading2 ? Container(
                color: Colors.white,
                child:const Center(
                  child: CircularProgressIndicator(),
                ),
              ) : errorMessage != "" ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage,style:const TextStyle(fontSize: 25),),
                    const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: () {
                        _getTreeGrowth();
                      },
                      child: OptionMcqAnswer(
                          TextButton(onPressed: () {
                            _getTreeGrowth();
                          }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                      ),
                    )
                  ],
                ),
              ) : Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                alignment: Alignment.bottomCenter,
                child:  widget.isAnimation ? AnimatedBuilder(
                  animation: controllerForward,
                  builder: (context, child) => FadeScaleTransition(
                    animation: controllerForward,
                    child: child,
                  ),
                  child:url == "" ? Container(
                    color: Colors.white,
                    child:const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : Image.asset(url,fit: BoxFit.fill,),

                  // CachedNetworkImage(
                  //     imageUrl: url,
                  //     fit: BoxFit.fill,
                  //     progressIndicatorBuilder: (context, url, downloadProgress) {
                  //       return Container(
                  //                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                  //                         child: CircularProgressIndicator(
                  //                             value: downloadProgress.progress));
                  //                   },
                  //     errorWidget: (context, url, error) => Container(
                  //         alignment: Alignment.center,
                  //         child: Icon(Icons.error,color: AppColors.redColor,)),
                  //   ),
                ) : _isLoading2 && countNumber2 == -1 ? Container(
                  color: Colors.white,
                  child:const Center(
                    child: CircularProgressIndicator(),
                  ),
                ) :  Image.asset(!isPhone ? "assets/apple_tree/apple_ipad/$countNumber2.png" : "assets/apple_tree/apple_mobile/$countNumber2.png",fit: BoxFit.fill,),
              ),
            ),
             GestureDetector(
               onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Dashboard()));
               },
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 40),
                 child: Align(
                   alignment: Alignment.bottomCenter,
                   child: Visibility(
                    visible: showTapHereButton,
                      child: Card(
                        color: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              child: const Text("Tap to proceed!",style: TextStyle(fontWeight: FontWeight.normal,fontSize: AppConstants.headingFontSize),))),
            ),
                 ),
               ),
             ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Dashboard()));
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    padding:const EdgeInsets.symmetric(horizontal: 10),
                    margin:const EdgeInsets.only(top: 20),
                    child: Text(element.toString(),style:const TextStyle(fontSize: AppConstants.defaultFontSize),textAlign: TextAlign.center,)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
