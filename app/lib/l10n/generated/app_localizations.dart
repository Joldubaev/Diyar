import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ky'),
    Locale('ru')
  ];

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccessfully;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active orders'**
  String get activeOrders;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Bishkek, Pobeda Avenue, 333'**
  String get address;

  /// No description provided for @addressD.
  ///
  /// In en, this message translates to:
  /// **'Address:'**
  String get addressD;

  /// No description provided for @addressIsCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get addressIsCopied;

  /// No description provided for @addressIsNotFounded.
  ///
  /// In en, this message translates to:
  /// **'Address is not found'**
  String get addressIsNotFounded;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added anything to the cart yet'**
  String get addToCart;

  /// No description provided for @adress.
  ///
  /// In en, this message translates to:
  /// **'Adress'**
  String get adress;

  /// No description provided for @adressD.
  ///
  /// In en, this message translates to:
  /// **'Bishkek city, Prospekt Pobedy Street, 333'**
  String get adressD;

  /// No description provided for @allAbout.
  ///
  /// In en, this message translates to:
  /// **'Express cafe, Restaurant, VIP rooms'**
  String get allAbout;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get areYouSure;

  /// No description provided for @areYouSureAddress.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change the address?'**
  String get areYouSureAddress;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Invalid login or password'**
  String get authError;

  /// No description provided for @authorize.
  ///
  /// In en, this message translates to:
  /// **'Authorize'**
  String get authorize;

  /// No description provided for @banket.
  ///
  /// In en, this message translates to:
  /// **'Banquet Hall'**
  String get banket;

  /// No description provided for @cabinet.
  ///
  /// In en, this message translates to:
  /// **'Cabinet'**
  String get cabinet;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Корзина'**
  String get cart;

  /// No description provided for @cartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartIsEmpty;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password successfully changed'**
  String get changePasswordSuccess;

  /// No description provided for @chooseAddress.
  ///
  /// In en, this message translates to:
  /// **'Choose address'**
  String get chooseAddress;

  /// No description provided for @chooseOnMap.
  ///
  /// In en, this message translates to:
  /// **'Choose on map'**
  String get chooseOnMap;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose time'**
  String get chooseTime;

  /// No description provided for @codeIntercom.
  ///
  /// In en, this message translates to:
  /// **'Code intercom'**
  String get codeIntercom;

  /// No description provided for @codeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Code update'**
  String get codeUpdate;

  /// No description provided for @coffe.
  ///
  /// In en, this message translates to:
  /// **'Coffe'**
  String get coffe;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get confirmOrder;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @costOfMeal.
  ///
  /// In en, this message translates to:
  /// **'Cost of meal'**
  String get costOfMeal;

  /// No description provided for @couldNotLaunch.
  ///
  /// In en, this message translates to:
  /// **'Could not launch'**
  String get couldNotLaunch;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create template'**
  String get createTemplate;

  /// No description provided for @cutlery.
  ///
  /// In en, this message translates to:
  /// **'Cutlery'**
  String get cutlery;

  /// No description provided for @dataIsLoaded.
  ///
  /// In en, this message translates to:
  /// **'Data is loaded'**
  String get dataIsLoaded;

  /// No description provided for @deleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Delete order'**
  String get deleteOrder;

  /// No description provided for @deleteOrderText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this order?'**
  String get deleteOrderText;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @deliveredText.
  ///
  /// In en, this message translates to:
  /// **'The courier delivered the food'**
  String get deliveredText;

  /// No description provided for @deliveredText2.
  ///
  /// In en, this message translates to:
  /// **'The courier is delivering food'**
  String get deliveredText2;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @deliveryCost.
  ///
  /// In en, this message translates to:
  /// **'Delivery cost:'**
  String get deliveryCost;

  /// No description provided for @deliveryPrice.
  ///
  /// In en, this message translates to:
  /// **'Delivery price'**
  String get deliveryPrice;

  /// No description provided for @deliveryService.
  ///
  /// In en, this message translates to:
  /// **'Diyaar Express'**
  String get deliveryService;

  /// No description provided for @deliveryServiceD.
  ///
  /// In en, this message translates to:
  /// **'Diyaar Express (table reservation)'**
  String get deliveryServiceD;

  /// No description provided for @deliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Delivery time:'**
  String get deliveryTime;

  /// No description provided for @dishes.
  ///
  /// In en, this message translates to:
  /// **'Dishes'**
  String get dishes;

  /// No description provided for @diyar.
  ///
  /// In en, this message translates to:
  /// **'Diyar'**
  String get diyar;

  /// No description provided for @diyar_sale.
  ///
  /// In en, this message translates to:
  /// **'Promotion \n on all dishes'**
  String get diyar_sale;

  /// No description provided for @diyarRestoran.
  ///
  /// In en, this message translates to:
  /// **'Diyaar Restaurant'**
  String get diyarRestoran;

  /// No description provided for @diyarRestoranHall.
  ///
  /// In en, this message translates to:
  /// **'Diyaar Banquet Hall'**
  String get diyarRestoranHall;

  /// No description provided for @ecpessCoffee.
  ///
  /// In en, this message translates to:
  /// **'Express Coffee'**
  String get ecpessCoffee;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'asanov@example.com'**
  String get emailExample;

  /// No description provided for @emptyText.
  ///
  /// In en, this message translates to:
  /// **'No data to display'**
  String get emptyText;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterAddress;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @enterCorrectCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the correct code'**
  String get enterCorrectCode;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enterPassword;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @entrance.
  ///
  /// In en, this message translates to:
  /// **'Entrance'**
  String get entrance;

  /// No description provided for @entranceNumber.
  ///
  /// In en, this message translates to:
  /// **'Entrance number'**
  String get entranceNumber;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get error;

  /// No description provided for @errorCompletingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error completing order'**
  String get errorCompletingOrder;

  /// No description provided for @errorLoadingActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'Error loading active orders'**
  String get errorLoadingActiveOrders;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @errorLoadingOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Error loading order history'**
  String get errorLoadingOrderHistory;

  /// No description provided for @errorRetrievingData.
  ///
  /// In en, this message translates to:
  /// **'Error retrieving data.'**
  String get errorRetrievingData;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @finishOrder.
  ///
  /// In en, this message translates to:
  /// **'Finish order:'**
  String get finishOrder;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @foodIsPrepared.
  ///
  /// In en, this message translates to:
  /// **'Food is being prepared'**
  String get foodIsPrepared;

  /// No description provided for @forAllFood.
  ///
  /// In en, this message translates to:
  /// **'For all dishes'**
  String get forAllFood;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @hall.
  ///
  /// In en, this message translates to:
  /// **'Hall'**
  String get hall;

  /// No description provided for @houseNumber.
  ///
  /// In en, this message translates to:
  /// **'House number'**
  String get houseNumber;

  /// No description provided for @kitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// No description provided for @lastNews.
  ///
  /// In en, this message translates to:
  /// **'Latest news'**
  String get lastNews;

  /// No description provided for @loadedWrong.
  ///
  /// In en, this message translates to:
  /// **'Data is loaded incorrectly'**
  String get loadedWrong;

  /// No description provided for @loadedWrongData.
  ///
  /// In en, this message translates to:
  /// **'Data is loaded incorrectly'**
  String get loadedWrongData;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid login or password'**
  String get loginError;

  /// No description provided for @look.
  ///
  /// In en, this message translates to:
  /// **'Look'**
  String get look;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameExample.
  ///
  /// In en, this message translates to:
  /// **'Example: John'**
  String get nameExample;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'You have no active orders yet'**
  String get noActiveOrders;

  /// No description provided for @noNews.
  ///
  /// In en, this message translates to:
  /// **'Now there are no news'**
  String get noNews;

  /// No description provided for @noOrderDescription.
  ///
  /// In en, this message translates to:
  /// **'You have not placed an order yet'**
  String get noOrderDescription;

  /// No description provided for @noOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'You have no order history yet'**
  String get noOrderHistory;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noOrders;

  /// No description provided for @noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhoneNumber;

  /// No description provided for @notActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'No active orders'**
  String get notActiveOrders;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get notAvailable;

  /// No description provided for @notAvailableTry.
  ///
  /// In en, this message translates to:
  /// **'Not available yet. Please try again later'**
  String get notAvailableTry;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing is found'**
  String get notFound;

  /// No description provided for @notHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get notHaveAccount;

  /// No description provided for @notImage.
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get notImage;

  /// No description provided for @ofice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get ofice;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Online payment'**
  String get onlinePayment;

  /// No description provided for @openOnMap.
  ///
  /// In en, this message translates to:
  /// **'Open on map'**
  String get openOnMap;

  /// No description provided for @operatorContact.
  ///
  /// In en, this message translates to:
  /// **'An operator will contact you within 5 minutes to confirm the order'**
  String get operatorContact;

  /// No description provided for @orderAmount.
  ///
  /// In en, this message translates to:
  /// **'Order amount:'**
  String get orderAmount;

  /// No description provided for @orderCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get orderCancel;

  /// No description provided for @orderCancelText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the order?'**
  String get orderCancelText;

  /// No description provided for @orderCancelText2.
  ///
  /// In en, this message translates to:
  /// **'You can cancel an order only before the start of preparation within:'**
  String get orderCancelText2;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order completed'**
  String get orderCompleted;

  /// No description provided for @orderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Order confirmation'**
  String get orderConfirmation;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetails;

  /// No description provided for @orderDetailsText.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetailsText;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get orderHistory;

  /// No description provided for @orderIsCanceled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get orderIsCanceled;

  /// No description provided for @orderIsCanceledText.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully cancelled'**
  String get orderIsCanceledText;

  /// No description provided for @orderIsFailed.
  ///
  /// In en, this message translates to:
  /// **'Order failed. Please try again'**
  String get orderIsFailed;

  /// No description provided for @orderIsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully'**
  String get orderIsSuccess;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order number:'**
  String get orderNumber;

  /// No description provided for @orderNumberIs.
  ///
  /// In en, this message translates to:
  /// **'Order number is:'**
  String get orderNumberIs;

  /// No description provided for @orderPickupAd.
  ///
  /// In en, this message translates to:
  /// **'You can pick up your order at the address'**
  String get orderPickupAd;

  /// No description provided for @orderRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat order'**
  String get orderRepeat;

  /// No description provided for @orderRepeatText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to repeat the order?'**
  String get orderRepeatText;

  /// No description provided for @orderTime.
  ///
  /// In en, this message translates to:
  /// **'In about 30 minutes your order will be ready'**
  String get orderTime;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password successfully changed'**
  String get passwordChanged;

  /// No description provided for @passwordRecovery.
  ///
  /// In en, this message translates to:
  /// **'Password recovery'**
  String get passwordRecovery;

  /// No description provided for @passwordRecoveryText.
  ///
  /// In en, this message translates to:
  /// **'Enter your E-Mail and recovery code, as well as the new password we sent to your email.'**
  String get passwordRecoveryText;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @payOnline.
  ///
  /// In en, this message translates to:
  /// **'Pay online'**
  String get payOnline;

  /// No description provided for @payWithCard.
  ///
  /// In en, this message translates to:
  /// **'Pay with card'**
  String get payWithCard;

  /// No description provided for @payWithCash.
  ///
  /// In en, this message translates to:
  /// **'Pay with cash'**
  String get payWithCash;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get pleaseEnterAddress;

  /// No description provided for @pleaseEnterChange.
  ///
  /// In en, this message translates to:
  /// **'Please enter the change'**
  String get pleaseEnterChange;

  /// No description provided for @pleaseEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter your recovery code'**
  String get pleaseEnterCode;

  /// No description provided for @pleaseEnterCorrectAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid address'**
  String get pleaseEnterCorrectAddress;

  /// No description provided for @pleaseEnterCorrectChange.
  ///
  /// In en, this message translates to:
  /// **'Change must be at least 1 character long'**
  String get pleaseEnterCorrectChange;

  /// No description provided for @pleaseEnterCorrectCode.
  ///
  /// In en, this message translates to:
  /// **'Recovery code must be 5 characters long'**
  String get pleaseEnterCorrectCode;

  /// No description provided for @pleaseEnterCorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid E-Mail'**
  String get pleaseEnterCorrectEmail;

  /// No description provided for @pleaseEnterCorrectHouseNumber.
  ///
  /// In en, this message translates to:
  /// **'House number must be at least 1 character long'**
  String get pleaseEnterCorrectHouseNumber;

  /// No description provided for @pleaseEnterCorrectName.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters long'**
  String get pleaseEnterCorrectName;

  /// No description provided for @pleaseEnterCorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 5 characters long'**
  String get pleaseEnterCorrectPassword;

  /// No description provided for @pleaseEnterCorrectPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 characters long'**
  String get pleaseEnterCorrectPhone;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your E-Mail'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterHouseNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your house number'**
  String get pleaseEnterHouseNumber;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the template name'**
  String get pleaseEnterTemplateName;

  /// No description provided for @pleaseTryLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later!'**
  String get pleaseTryLater;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get policy;

  /// No description provided for @popularFood.
  ///
  /// In en, this message translates to:
  /// **'Popular dishes'**
  String get popularFood;

  /// No description provided for @postTerminal.
  ///
  /// In en, this message translates to:
  /// **'Post terminal'**
  String get postTerminal;

  /// No description provided for @preparingForThe.
  ///
  /// In en, this message translates to:
  /// **'Prepare for'**
  String get preparingForThe;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @receiveCode.
  ///
  /// In en, this message translates to:
  /// **'We sent you a code to the specified phone number.'**
  String get receiveCode;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @regenerateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Regeneration available in'**
  String get regenerateAvailable;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resgisterIsFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get resgisterIsFailed;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Акции'**
  String get sale;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search ...'**
  String get search;

  /// No description provided for @searchByNames.
  ///
  /// In en, this message translates to:
  /// **'Search by names'**
  String get searchByNames;

  /// No description provided for @searchMeal.
  ///
  /// In en, this message translates to:
  /// **'Search meal'**
  String get searchMeal;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @som.
  ///
  /// In en, this message translates to:
  /// **'som'**
  String get som;

  /// No description provided for @someThingIsWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get someThingIsWrong;

  /// No description provided for @templateDescription.
  ///
  /// In en, this message translates to:
  /// **'Having created a template, you can select it so that all order fields are automatically filled in as you specified'**
  String get templateDescription;

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get templateName;

  /// No description provided for @termsAccept.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms of the user agreement'**
  String get termsAccept;

  /// No description provided for @termsAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms of the user agreement'**
  String get termsAgree;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'from 09:00 to 23:00'**
  String get time;

  /// No description provided for @timeD.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeD;

  /// No description provided for @timeToWork.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get timeToWork;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount:'**
  String get totalAmount;

  /// No description provided for @totalOrderAmount.
  ///
  /// In en, this message translates to:
  /// **'Total order amount'**
  String get totalOrderAmount;

  /// No description provided for @totalToPay.
  ///
  /// In en, this message translates to:
  /// **'Total to pay without delivery'**
  String get totalToPay;

  /// No description provided for @totalWithDelivery.
  ///
  /// In en, this message translates to:
  /// **'Total with delivery'**
  String get totalWithDelivery;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @versal.
  ///
  /// In en, this message translates to:
  /// **'Versailles'**
  String get versal;

  /// No description provided for @vip.
  ///
  /// In en, this message translates to:
  /// **'VIP Hall'**
  String get vip;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yourAddress.
  ///
  /// In en, this message translates to:
  /// **'Your address'**
  String get yourAddress;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @yourOrdersConfirm.
  ///
  /// In en, this message translates to:
  /// **'Your orders are confirmed'**
  String get yourOrdersConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
