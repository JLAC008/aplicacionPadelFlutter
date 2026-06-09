import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';

class ChatScreen extends StatefulWidget {
  final Challenge challenge;
  const ChatScreen({super.key, required this.challenge});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<ChatMessage> _messages;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  Timer? _autoReplyTimer;
  bool _isWaitingForReply = false;
  double _sendScale = 1.0;

  Player get _myCaptain => widget.challenge.challenger.player1;
  Player get _otherCaptain => widget.challenge.challenged.player1;

  @override
  void initState() {
    super.initState();
    _messages = List.from(mockChats[widget.challenge.id] ?? []);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _autoReplyTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _myCaptain.id,
        senderName: _myCaptain.name,
        text: text,
        timestamp: DateTime.now(),
        avatarUrl: _myCaptain.avatarUrl,
      ));
      _controller.clear();
    });
    _scrollToBottom();

    _autoReplyTimer?.cancel();
    setState(() {
      _isWaitingForReply = true;
    });
    _autoReplyTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isWaitingForReply = false;
        _messages.add(ChatMessage(
          id: 'm_${DateTime.now().millisecondsSinceEpoch}',
          senderId: _otherCaptain.id,
          senderName: _otherCaptain.name,
          text: _randomReply(),
          timestamp: DateTime.now(),
          avatarUrl: _otherCaptain.avatarUrl,
        ));
      });
      _scrollToBottom();
    });
  }

  String _randomReply() {
    final replies = [
      'Suena bien!',
      'Perfecto, confirmado.',
      'Ok, nos vemos allí.',
      'Genial!',
      'De acuerdo.',
      'Vamos allá!',
    ];
    return replies[DateTime.now().millisecondsSinceEpoch % replies.length];
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSendPressed() {
    setState(() => _sendScale = 0.8);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _sendScale = 1.0);
    });
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kGold, kTeal],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _otherCaptain.avatarUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: kCardBorder,
                    child: const Icon(Icons.person, color: kTextSecondary, size: 16),
                  ),
                  placeholder: (_, __) => Container(color: kCardBorder),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_otherCaptain.name} (capitán)',
                      style: const TextStyle(fontSize: 14, color: kTextPrimary)),
                  Text(widget.challenge.ligaName,
                      style: const TextStyle(fontSize: 11, color: kTextSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Challenge info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: kCard,
              border: Border(bottom: BorderSide(color: kCardBorder.withOpacity(0.3))),
            ),
            child: Row(
              children: [
                PairAvatars(
                  url1: widget.challenge.challenger.player1.avatarUrl,
                  url2: widget.challenge.challenger.player2.avatarUrl,
                  radius: 14,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.sports_tennis, color: kGold, size: 14),
                const SizedBox(width: 8),
                PairAvatars(
                  url1: widget.challenge.challenged.player1.avatarUrl,
                  url2: widget.challenge.challenged.player2.avatarUrl,
                  radius: 14,
                ),
                const Spacer(),
                StatusChip(
                  label: _statusLabel(widget.challenge.status),
                  color: _statusColor(widget.challenge.status),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: _messages.isEmpty && !_isWaitingForReply
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            color: kTextSecondary, size: 48),
                        SizedBox(height: 12),
                        Text('Sin mensajes todavía',
                            style: TextStyle(color: kTextSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _MessageBubble(
                      message: _messages[i],
                      isMine: _messages[i].senderId == _myCaptain.id,
                      index: i,
                    ),
                  ),
          ),
          // Typing indicator
          if (_isWaitingForReply) const _TypingIndicator(),
          // Input
          Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: kCardBorder.withOpacity(0.3))),
              color: kBg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(color: kTextPrimary),
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        hintStyle: const TextStyle(color: kTextSecondary),
                        filled: true,
                        fillColor: kCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              const BorderSide(color: kGold, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _onSendPressed(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: _onSendPressed,
                    child: AnimatedScale(
                      scale: _sendScale,
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kGold),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: kOnGold, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(ChallengeStatus s) {
    switch (s) {
      case ChallengeStatus.pending:
        return Colors.orange;
      case ChallengeStatus.accepted:
        return kTeal;
      case ChallengeStatus.awaitingVerification:
        return Colors.amber;
      case ChallengeStatus.completed:
        return Colors.green;
      case ChallengeStatus.rejected:
        return Colors.red;
    }
  }

  String _statusLabel(ChallengeStatus s) {
    switch (s) {
      case ChallengeStatus.pending:
        return 'Pendiente';
      case ChallengeStatus.accepted:
        return 'Aceptado';
      case ChallengeStatus.awaitingVerification:
        return 'Por verificar';
      case ChallengeStatus.completed:
        return 'Completado';
      case ChallengeStatus.rejected:
        return 'Rechazado';
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final int index;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final time =
        '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            Container(
              width: 31,
              height: 31,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kGold, kTeal],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: message.avatarUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                        color: kCardBorder,
                        child: const Icon(
                            Icons.person, color: kTextSecondary, size: 14)),
                    placeholder: (_, __) => Container(color: kCardBorder),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isMine ? kGold : kCard,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(isMine ? 20 : 4),
                  topRight:
                      Radius.circular(isMine ? 4 : 20),
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isMine)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(message.senderName,
                          style: const TextStyle(
                              color: kTeal,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  Text(message.text,
                      style: TextStyle(
                          color: isMine ? kOnGold : kTextPrimary,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(time,
                      style: TextStyle(
                          color: isMine
                              ? kOnGold.withValues(alpha: 0.6)
                              : kTextSecondary,
                          fontSize: 10)),
                ],
              ),
            ),
          ),
          if (isMine) ...[
            const SizedBox(width: 8),
            Container(
              width: 31,
              height: 31,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kGold, kTeal],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: message.avatarUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                        color: kCardBorder,
                        child: const Icon(
                            Icons.person, color: kTextSecondary, size: 14)),
                    placeholder: (_, __) => Container(color: kCardBorder),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: index * 60),
          curve: Curves.easeOut,
        )
        .slideX(
          begin: isMine ? 0.4 : -0.4,
          end: 0,
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: index * 60),
          curve: Curves.easeOutCubic,
        );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4, top: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: kShadowColor.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final delay = i * 0.15;
                    final t = (_controller.value - delay).clamp(0.0, 1.0);
                    final scale =
                        1.0 + 0.5 * (t < 0.5 ? t * 2 : 2.0 - t * 2);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Transform.scale(
                        scale: scale.clamp(0.6, 1.5),
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: kTextSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
