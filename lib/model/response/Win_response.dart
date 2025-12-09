// ignore_for_file: file_names

class AuctionWin {
  final dynamic auctionId;
  final dynamic maxBid;
  final String? message;
  final String? status;
  final String? timestamp;
  final dynamic winnerId;

  AuctionWin({
    this.auctionId,
    this.maxBid,
    this.message,
    this.status,
    this.timestamp,
    this.winnerId,
  });

  // Factory method to create an instance from JSON
  factory AuctionWin.fromJson(Map<String, dynamic> json) {
    return AuctionWin(
      auctionId: json['acution_id'],
      maxBid: json['max_bid'],
      message: json['message'],
      status: json['status'],
      timestamp: json['timestamp'],
      winnerId: json['winner_id'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'acution_id': auctionId,
      'max_bid': maxBid,
      'message': message,
      'status': status,
      'timestamp': timestamp,
      'winner_id': winnerId,
    };
  }
}
