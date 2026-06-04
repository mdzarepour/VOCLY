import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/common/constants/const_icons.dart';
import 'package:vocly/core/enums/enums.dart';

class ConstWordTypes {
  ConstWordTypes._();
  static const wordTypes = [
    'Article',
    'Pronoun',
    'Conjunction',
    'Adjective',
    'Preposition',
    'Adverb',
    'Verb',
    'Noun',
  ];
}

class UIStrings {
  UIStrings._();
  static const appName = 'VOCLY';
  static const newBook = 'New book';
  static const newWord = 'New word';
  static const addNewBook = 'Add new book';
  static const editWord = 'Edit word';
  static const bookReview = 'Book review';
  static const wordReview = 'Word review';
  static const words = 'Words';
  static const details = 'Details';
  static const visual = 'Visual';
  static const name = 'Name';
  static const description = 'Description';
  static const meaning = 'Meaning';
  static const example = 'Example';
  static const icon = 'Icon';
  static const type = 'Type';
  static const color = 'Color';
  static const done = 'Done';

  static const cancel = 'Cancel';
  static const spellingPractice = 'Spelling practice';
  static const edit = 'Edit';
  static const listen = 'Listen';
  static const delete = 'delete';
  static const deleting = 'Deleting!';
  static const thereIsNoBookYet = 'there is no book yet!';
  static const thereIsNoWordYet = 'There is no word yet';
  static const addBooks = 'Add books';
  static const manageBooks = 'Manage books';
  static const manageWords = 'Manage words';
  static const addWords = 'Add words';
  static const pleaseEnter = 'Please enter';
  static const sortWords = 'Sort words';
  static const book = 'Book';
  static const settings = 'settings';
  static const shareToFriends = 'share to friends';
  static const donationToCreator = 'donation to creator';
  static const helpAndFeedback = 'Help & feedback';
  static const home = 'Home';
  static const practice = 'Practice';
  static const exam = 'Exam';
  static const search = 'Search';
  static const yourVocabulary = 'You vocabulary';
  static const yourData = 'You data';
  static const exportYour = 'Export your';
  static const exportYourDataDescription = 'Export your words as pdf file';
  static const importYourData = 'Import your data';
  static const importPreviouslySavedVocabulary =
      'Import your previously saved vocabulary';
  static const data = 'data';
  static const books = 'books';
}

class AppStrings {
  AppStrings._();
  static const wordBox = 'WordBox';
  static const bookBox = 'BookBox';
  static const languageEnUs = 'en-US';
  static const emptyChar = '';

  // Map keys
  static const keyName = 'name';
  static const keyDescription = 'description';
  static const keyColor = 'color';
  static const keyBanner = 'banner';
  static const keyWords = 'words';
  static const keyMeaning = 'meaning';
  static const keyExample = 'example';
  static const keyType = 'type';
  static const keyIcon = 'icon';
  static const keyFilterItems = 'FilterItems';

  // Dialogs
  static const dialogDuplicatedBookTitle = 'Duplicated book!';
  static const dialogDuplicatedBookContent =
      'Are you sure want to add duplicated book?';
  static const dialogDuplicatedBookConfirm = 'Yes add';
  static const dialogDuplicatedWordTitle = 'Duplicated word!';
  static const dialogDuplicatedWordContent =
      'Are you sure want to add duplicated word?';
  static const dialogDuplicatedWordConfirm = 'Yes add';
  static const dialogConfirmDeleteTitle = 'Deleting!';
  static const dialogConfirmDeleteBooksContent =
      'Are you sure about deleting these books?';
  static const dialogConfirmDeleteWordsContent =
      'Are you sure about deleting these words?';
  static const dialogConfirmDeleteAction = 'delete';
  static const bookWordsCount = 'You have {count} words in this book';

  static const List<Map> wordFilteringItems = [
    {
      AppStrings.keyName: AppStrings.keyColor,
      AppStrings.keyType: FilterType.color,
      AppStrings.keyFilterItems: ConstEntityColors.colors,
    },
    {
      AppStrings.keyName: AppStrings.keyIcon,
      AppStrings.keyType: FilterType.icon,
      AppStrings.keyFilterItems: ConstIcons.icons,
    },
    {
      AppStrings.keyName: AppStrings.keyType,
      AppStrings.keyType: FilterType.type,
      AppStrings.keyFilterItems: ConstWordTypes.wordTypes,
    },
  ];
}
