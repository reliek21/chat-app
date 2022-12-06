import 'package:chat_app/common/constants.dart';
import 'package:chat_app/core/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage()
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};

  @override
  void initState() {
    final String myUserId = supabase.auth.currentUser!.id;

    _messagesStream = supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .map((maps) => maps
        .map((map) => Message.fromMap(
          map: map,
          myUserId: myUserId
        )).toList()
      );

    super.initState();
  }

  Future<void> _loadProfileCache(String profileId) async {
    if(_profileCache[profileId] != null) {
      return;
    }

    final dynamic data = await supabase.from('profiles')
      .select().eq('id', profileId).single();

    final Profile profile = Profile.fromMap(data);

    setState(() {
      _profileCache[profileId] = profile;
    });
  }

  Widget _buildMessages(List<Message> messages) {
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
            ? const Center(
              child: Text('Start your conversation now :)'),
            )
            : ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                _loadProfileCache(message.profileId);

                return _ChatBubble(
                  message: message,
                  profile: _profileCache[message.profileId]
                );
              },
            ),
        ),
        const _MessageBar()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final messages = snapshot.data!;
            return _buildMessages(messages);
          } else {
            return preloader;
          }
        }
      )
    );
  }
}

// set of widget that constains TextField and Button to submit message

class _MessageBar extends StatefulWidget {
  const _MessageBar();

  @override
  State<_MessageBar> createState() => __MessageBarState();
}

class __MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  void _submitMessage() async {
    final text = _textController.text;
    final myUserId = supabase.auth.currentUser!.id;

    if(text.isEmpty) {
      return;
    }

    _textController.clear();

    try {
      await supabase.from('messages').insert({
        'profile_id': myUserId,
        'content': text
      });
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0)
                  ),
                ),
              ),TextButton(
                onPressed: () => _submitMessage(),
                child: const Text('Send')
              )
            ],
          )
        )
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final Message message;
  final Profile? profile;

  const _ChatBubble({required this.message, required this.profile});

  Widget isMineMessage(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0
        ),
        decoration: BoxDecoration(
          color: message.isMine
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Text(message.content)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if(!message.isMine)
        CircleAvatar(
          child: profile == null
            ? preloader
            : Text(profile!.username.substring(0, 2)),
        ),
      
      const SizedBox(width: 12.0),
      isMineMessage(context),
      const SizedBox(width: 12.0),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60.0),
    ];

    if(message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 18.0
      ),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end
          : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}