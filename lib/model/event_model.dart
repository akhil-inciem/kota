class EventsModel {
    EventsModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final List<EventsDatum> data;

    factory EventsModel.fromJson(Map<String, dynamic> json){ 
        return EventsModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<EventsDatum>.from(json["data"]!.map((x) => EventsDatum.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
    };

}

class EventsDatum {
    EventsDatum({
        required this.eventId,
        required this.eventTitle,
        required this.eventName,
        required this.eventShortDescription,
        required this.eventDescription,
        required this.eventstartDateDate,
        required this.eventEndDate,
        required this.totalSeats,
        required this.addedBy,
        required this.addedOn,
        required this.image,
        required this.document,
        required this.status,
        required this.feesPerSeat,
        required this.location,
        required this.onlineBooking,
        // required this.badges,
        // required this.faverites,
    });

    final String? eventId;
    final String? eventTitle;
    final String? eventName;
    final String? eventShortDescription;
    final String? eventDescription;
    final DateTime? eventstartDateDate;
    final DateTime? eventEndDate;
    final String? totalSeats;
    final String? addedBy;
    final String? addedOn;
    final String? image;
    final String? document;
    final String? status;
    final String? feesPerSeat;
    final String? location;
    final String? onlineBooking;
    // final dynamic badges;
    // final dynamic faverites;

    factory EventsDatum.fromJson(Map<String, dynamic> json){ 
        return EventsDatum(
            eventId: json["event_id"],
            eventTitle: json["event_title"],
            eventName: json["event_name"],
            eventShortDescription: json["event_short_description"],
            eventDescription: json["event_description"],
            eventstartDateDate: DateTime.tryParse(json["eventstart_date_date"] ?? ""),
            eventEndDate: DateTime.tryParse(json["event_end_date"] ?? ""),
            totalSeats: json["total_seats"],
            addedBy: json["added_by"],
            addedOn: json["added_on"],
            image: json["image"],
            document: json["document"],
            status: json["status"],
            feesPerSeat: json["fees_per_seat"],
            location: json["location"],
            onlineBooking: json["online_booking"],
            // badges: json["badges"],
            // faverites: json["faverites"],
        );
    }

    Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "event_title": eventTitle,
        "event_name": eventName,
        "event_short_description": eventShortDescription,
        "event_description": eventDescription,
        "eventstart_date_date": "${eventstartDateDate!.year.toString().padLeft(4,'0')}-${eventstartDateDate!.month.toString().padLeft(2,'0')}-${eventstartDateDate!.day.toString().padLeft(2,'0')}",
        "event_end_date": "${eventEndDate!.year.toString().padLeft(4,'0')}-${eventEndDate!.month.toString().padLeft(2,'0')}-${eventEndDate!.day.toString().padLeft(2,'0')}",
        "total_seats": totalSeats,
        "added_by": addedBy,
        "added_on": addedOn,
        "image": image,
        "document": document,
        "status": status,
        "fees_per_seat": feesPerSeat,
        "location": location,
        "online_booking": onlineBooking,
        // "badges": badges,
        // "faverites": faverites,
    };

}
