import Foundation
import Parse
import Atlas

extension User: ATLParticipant {

    var firstName: String {
        return self.firstname
    }

    var lastName: String {
        return self.lastname
    }

    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }

    var participantIdentifier: String {
        return self.objectId!
    }

    var avatarImageURL: NSURL? {
        return nil
    }

    var avatarImage: UIImage? {
        return nil
    }

    var avatarInitials: String {
        let initials = "\(getFirstCharacter(self.firstName))\(getFirstCharacter(self.lastName))"
        return initials.uppercaseString
    }
    
    private func getFirstCharacter(value: String) -> String {
        return (value as NSString).substringToIndex(1)
    }
}