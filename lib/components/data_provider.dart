import 'package:inkora/models/group.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/models/message.dart';

class DataProvider {
  // Current user
  static final User currentUser = User(
  id: 1,
  lastName: 'Smith',
  firstName: 'John',
  email: 'john.smith@example.com',
  password: 'password123',
  gender: 'male',
  registrationDate: DateTime(2023, 5, 15),
  status: 'active',
  photo: 'assets/images/profile1.jpg',
  username: 'johnsmith',  // Added username
  bio: 'A passionate software developer',  // Added bio
);

// Sample users
static final List<User> users = [
  currentUser,
  User(
    id: 2,
    lastName: 'Johnson',
    firstName: 'Emily',
    email: 'emily.j@example.com',
    password: 'password123',
    gender: 'female',
    registrationDate: DateTime(2023, 6, 10),
    status: 'active',
    photo: 'assets/images/profile2.jpg',
    username: 'emilyjohnson',  // Added username
    bio: 'Loves to code and explore new tech',  // Added bio
  ),
  User(
    id: 3,
    lastName: 'Williams',
    firstName: 'Michael',
    email: 'michael.w@example.com',
    password: 'password123',
    gender: 'male',
    registrationDate: DateTime(2023, 7, 5),
    status: 'active',
    photo: 'assets/images/profile3.jpg',
    username: 'michaelwilliams',  // Added username
    bio: 'Tech enthusiast and gamer',  // Added bio
  ),
  User(
    id: 4,
    lastName: 'Brown',
    firstName: 'Sophia',
    email: 'sophia.b@example.com',
    password: 'password123',
    gender: 'female',
    registrationDate: DateTime(2023, 8, 20),
    status: 'active',
    photo: 'assets/images/profile4.jpg',
    username: 'sophiabrown',  // Added username
    bio: 'Creative designer and artist',  // Added bio
  ),
  User(
    id: 5,
    lastName: 'Davis',
    firstName: 'James',
    email: 'james.d@example.com',
    password: 'password123',
    gender: 'male',
    registrationDate: DateTime(2023, 9, 12),
    status: 'active',
    photo: 'assets/images/profile5.jpg',
    username: 'jamesdavis',  // Added username
    bio: 'Business professional with a passion for tech',  // Added bio
  ),
  User(
    id: 6,
    lastName: 'Miller',
    firstName: 'Olivia',
    email: 'olivia.m@example.com',
    password: 'password123',
    gender: 'female',
    registrationDate: DateTime(2023, 10, 8),
    status: 'active',
    photo: 'assets/images/profile6.jpg',
    username: 'oliviamiller',  // Added username
    bio: 'Aspiring developer and tech lover',  // Added bio
  ),
  User(
    id: 7,
    lastName: 'Wilson',
    firstName: 'Noah',
    email: 'noah.w@example.com',
    password: 'password123',
    gender: 'male',
    registrationDate: DateTime(2023, 11, 15),
    status: 'active',
    photo: 'assets/images/profile7.jpg',
    username: 'noahwilson',  // Added username
    bio: 'Music lover and coding enthusiast',  // Added bio
  ),
  User(
    id: 8,
    lastName: 'Taylor',
    firstName: 'Emma',
    email: 'emma.t@example.com',
    password: 'password123',
    gender: 'female',
    registrationDate: DateTime(2023, 12, 3),
    status: 'active',
    photo: 'assets/images/profile8.jpg',
    username: 'emmataylor',  // Added username
    bio: 'Enjoys writing and tech innovations',  // Added bio
  ),
];

  // Sample groups
  static final List<Group> groups = [
    Group(
      id: 1,
      name: 'Fantasy Besties',
      description: 'A group for fantasy book lovers',
      creatorId: 1, // Current user is creator
      creationDate: DateTime(2023, 9, 15),
      members: [1, 2, 3, 4, 5],
      photo: 'assets/images/fantasy.jpg',
    ),
    Group(
      id: 2,
      name: 'Harry Potter',
      description: 'Discussing all things Harry Potter',
      creatorId: 1, // Current user is creator
      creationDate: DateTime(2023, 10, 5),
      members: [1, 2, 3, 6],
      photo: 'assets/images/harry_potter.jpg',
    ),
    Group(
      id: 3,
      name: 'Science Fiction',
      description: 'For sci-fi enthusiasts',
      creatorId: 2,
      creationDate: DateTime(2023, 11, 10),
      members: [1, 2, 4, 7], // Current user is member
      photo: 'assets/images/scifi.jpg',
    ),
    Group(
      id: 4,
      name: 'Mystery Novels',
      description: 'Discussing mystery and thriller books',
      creatorId: 3,
      creationDate: DateTime(2023, 12, 20),
      members: [1, 3, 4, 8], // Current user is member
      photo: 'assets/images/mystery.jpg',
    ),
    Group(
      id: 5,
      name: 'Classic Literature',
      description: 'For lovers of classic literature',
      creatorId: 4,
      creationDate: DateTime(2024, 1, 15),
      members: [1, 2, 4, 5, 8], // Current user is member
      photo: 'assets/images/classics.jpg',
    ),
    Group(
      id: 6,
      name: 'Romance Readers',
      description: 'Discussing romance novels and authors',
      creatorId: 5,
      creationDate: DateTime(2024, 2, 10),
      members: [2, 4, 5, 6, 8],
      photo: 'assets/images/romance.jpg',
    ),
    Group(
      id: 7,
      name: 'Horror Fiction',
      description: 'For fans of horror and supernatural fiction',
      creatorId: 6,
      creationDate: DateTime(2024, 3, 5),
      members: [3, 5, 6, 7],
      photo: 'assets/images/horror.jpg',
    ),
    Group(
      id: 8,
      name: 'Poetry Circle',
      description: 'Sharing and discussing poetry',
      creatorId: 7,
      creationDate: DateTime(2024, 3, 20),
      members: [2, 4, 7, 8],
      photo: 'assets/images/poetry.jpg',
    ),
  ];

  // Sample messages for Fantasy Besties group (Group ID 1)
  static final List<Message> messagesFantasyBesties = [
    Message(
      id: 1,
      senderId: 1, // Current user
      groupId: 1,
      content: 'Guys did you read the latest chapters of Kingdom of fire ... period 🔥',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Message(
      id: 2,
      senderId: 2,
      groupId: 1,
      content: 'I diiid i think i\'m in love with the new caracter ❤️💕',
      timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
    ),
    Message(
      id: 3,
      senderId: 3,
      groupId: 1,
      content: 'nooo don\'t spoil ☺️❤️ i didn\'t read it yet',
      timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
    ),
    Message(
      id: 4,
      senderId: 4,
      groupId: 1,
      content: 'yeaaah i did came out last week ... happy (: ',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    Message(
      id: 5,
      senderId: 1, // Current user
      groupId: 1,
      content: 'no waaay you should read it right now 😮🔥🔥',
      timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
    ),
    Message(
      id: 6,
      senderId: 2,
      groupId: 1,
      content: '',
      imageUrl: 'assets/images/map.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    Message(
      id: 7,
      senderId: 5,
      groupId: 1,
      content: 'I just started reading it! The world-building is amazing!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      id: 8,
      senderId: 1,
      groupId: 1,
      content: 'Right?? The author really outdid themselves this time',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Message(
      id: 9,
      senderId: 3,
      groupId: 1,
      content: 'Ok I\'m convinced, I\'ll start reading tonight 📚',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
  ];

  // Sample messages for Harry Potter group (Group ID 2)
  static final List<Message> messagesHarryPotter = [
    Message(
      id: 1,
      senderId: 1,
      groupId: 2,
      content: 'Which book in the series is your favorite?',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Message(
      id: 2,
      senderId: 3,
      groupId: 2,
      content: 'Prisoner of Azkaban for sure! Time travel and Sirius Black 🙌',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
    ),
    Message(
      id: 3,
      senderId: 2,
      groupId: 2,
      content: 'I love Half-Blood Prince. So much backstory!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
    ),
    Message(
      id: 4,
      senderId: 6,
      groupId: 2,
      content: 'Goblet of Fire for me - the Triwizard Tournament was epic',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
    ),
    Message(
      id: 5,
      senderId: 1,
      groupId: 2,
      content: 'I think mine is Order of the Phoenix, even though it\'s so sad at the end 😢',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 35)),
    ),
    Message(
      id: 6,
      senderId: 2,
      groupId: 2,
      content: '',
      imageUrl: 'assets/images/hogwarts.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
    ),
    Message(
      id: 7,
      senderId: 2,
      groupId: 2,
      content: 'Found this amazing artwork of Hogwarts!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 29)),
    ),
    Message(
      id: 8,
      senderId: 6,
      groupId: 2,
      content: 'Wow that\'s beautiful! 😍',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 25)),
    ),
  ];

  // Sample messages for Science Fiction group (Group ID 3)
  static final List<Message> messagesSciFi = [
    Message(
      id: 1,
      senderId: 2,
      groupId: 3,
      content: 'Has anyone read Dune? The new movie got me interested in the books',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    Message(
      id: 2,
      senderId: 1,
      groupId: 3,
      content: 'Yes! The books are amazing, much more detailed than the movies',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4, minutes: 50)),
    ),
    Message(
      id: 3,
      senderId: 4,
      groupId: 3,
      content: 'I\'ve read the first three. They get pretty complex but worth it!',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4, minutes: 45)),
    ),
    Message(
      id: 4,
      senderId: 7,
      groupId: 3,
      content: 'I prefer Foundation by Asimov if we\'re talking classic sci-fi',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4, minutes: 40)),
    ),
    Message(
      id: 5,
      senderId: 2,
      groupId: 3,
      content: 'I\'ll add that to my reading list too!',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4, minutes: 35)),
    ),
    Message(
      id: 6,
      senderId: 1,
      groupId: 3,
      content: 'What did everyone think of the new Dune movie?',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Message(
      id: 7,
      senderId: 7,
      groupId: 3,
      content: 'Visually stunning! Denis Villeneuve is a master',
      timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 55)),
    ),
  ];

  // Sample messages for Mystery Novels group (Group ID 4)
  static final List<Message> messagesMystery = [
    Message(
      id: 1,
      senderId: 3,
      groupId: 4,
      content: 'Who\'s your favorite mystery author?',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
    ),
    Message(
      id: 2,
      senderId: 1,
      groupId: 4,
      content: 'Agatha Christie, the queen of mystery! 👑',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 55)),
    ),
    Message(
      id: 3,
      senderId: 8,
      groupId: 4,
      content: 'I love Gillian Flynn - Gone Girl was mind-blowing',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 50)),
    ),
    Message(
      id: 4,
      senderId: 4,
      groupId: 4,
      content: 'Arthur Conan Doyle - Sherlock Holmes stories are timeless',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 45)),
    ),
    Message(
      id: 5,
      senderId: 3,
      groupId: 4,
      content: 'I\'m reading a Tana French novel right now - so atmospheric!',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 40)),
    ),
  ];

  // Sample messages for Classic Literature group (Group ID 5)
  static final List<Message> messagesClassics = [
    Message(
      id: 1,
      senderId: 4,
      groupId: 5,
      content: 'What classic novel do you think everyone should read?',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
    ),
    Message(
      id: 2,
      senderId: 1,
      groupId: 5,
      content: 'To Kill a Mockingbird - still so relevant today',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 9, minutes: 55)),
    ),
    Message(
      id: 3,
      senderId: 2,
      groupId: 5,
      content: 'Pride and Prejudice! Jane Austen was ahead of her time',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 9, minutes: 50)),
    ),
    Message(
      id: 4,
      senderId: 5,
      groupId: 5,
      content: '1984 by Orwell - especially in today\'s world',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 9, minutes: 45)),
    ),
    Message(
      id: 5,
      senderId: 8,
      groupId: 5,
      content: 'The Great Gatsby - beautiful prose and such a tragic story',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 9, minutes: 40)),
    ),
    Message(
      id: 6,
      senderId: 1,
      groupId: 5,
      content: 'Has anyone read War and Peace? I\'m intimidated by the length 😅',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    Message(
      id: 7,
      senderId: 5,
      groupId: 5,
      content: 'I have! It\'s long but worth it. Just take your time with it',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 55)),
    ),
  ];

  // Map to store messages for each group
  static final Map<int, List<Message>> allMessages = {
    1: messagesFantasyBesties,
    2: messagesHarryPotter,
    3: messagesSciFi,
    4: messagesMystery,
    5: messagesClassics,
  };

  // Get user by ID
 static User getUserById(int userId) {
  return users.firstWhere(
    (user) => user.id == userId,
    orElse: () => User(
      id: 0,
      lastName: 'Unknown',
      firstName: 'User',
      email: 'unknown@example.com',
      password: '',
      gender: 'unknown',
      registrationDate: DateTime.now(),
      status: 'unknown',
      photo: 'assets/images/default_profile.jpg',
      username: 'unknown_user',  // Default username
      bio: 'No bio available',   // Default bio
    ),
  );
}


  // Get groups where user is creator
  static List<Group> getCreatedGroups(int userId) {
    return groups.where((group) => group.creatorId == userId).toList();
  }

  // Get groups where user is a member but not creator
  static List<Group> getMemberGroups(int userId) {
    return groups.where((group) => 
      group.members?.contains(userId) == true && 
      group.creatorId != userId
    ).toList();
  }

  // Get messages for a specific group
  static List<Message> getGroupMessages(int groupId) {
    return allMessages[groupId] ?? [];
  }

  // Add a new message
  static Message addMessage(int senderId, int groupId, String content, {String? imageUrl}) {
    // Get the messages list for this group, or create a new one if it doesn't exist
    final messages = allMessages[groupId] ?? [];
    if (allMessages[groupId] == null) {
      allMessages[groupId] = messages;
    }
    
    // Create a new message
    final newMessage = Message(
      id: messages.isEmpty ? 1 : messages.last.id + 1,
      senderId: senderId,
      groupId: groupId,
      content: content,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );
    
    // Add the message to the list
    messages.add(newMessage);
    
    return newMessage;
  }

  // Update a group
  static void updateGroup(Group updatedGroup) {
    final index = groups.indexWhere((group) => group.id == updatedGroup.id);
    if (index != -1) {
      groups[index] = updatedGroup;
    }
  }

  // Get a fallback image for groups
  static String getFallbackGroupImage(int groupId) {
    final images = [
      'assets/images/book_cover.jpeg',
      'assets/images/book_cover2.jpeg',
      'assets/images/book_cover3.jpeg',
    ];
    return images[groupId % images.length];
  }

  // Get a fallback image for users
  static String getFallbackUserImage(int userId) {
    return 'assets/images/default_profile.jpg';
  }
}
