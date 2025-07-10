class ChatService {
  // Static map of predefined questions and answers
  static final Map<String, String> _qaPairs = {
    'what is trackwise':
        'TrackWise is a finance management app to track your budget, expenses, and savings.',
    'who created this app': 'This app was created by Lakshya.',
    'how to check my balance':
        'Go to your profile page and tap "Click to see your bank" to check your balance.',
    'what is flutter':
        'Flutter is an open-source UI toolkit by Google for building apps from a single codebase.',
    'what is the capital of india': 'The capital of India is New Delhi.',
    'who is the prime minister of india':
        'Narendra Modi is the Prime Minister of India.',
  };

  // Chat response handler
  static Future<String> sendMessage(String message) async {
    final cleaned = message.trim().toLowerCase();

    // Exact match first
    if (_qaPairs.containsKey(cleaned)) {
      return _qaPairs[cleaned]!;
    }

    // Fallback: Loose match by keyword
    for (final entry in _qaPairs.entries) {
      if (cleaned.contains(entry.key)) {
        return entry.value;
      }
    }

    return "I'm sorry, I don't know the answer to that.";
  }
}
