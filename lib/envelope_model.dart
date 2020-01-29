
//Model class for envelope
class EnvelopeModel{
  String envelopeName;
  String envelopeType;
  String initialValue;
  String additionalNotes;
  EnvelopeModel(String envelopeName, String initialValue, [String envelopeType, String additionalNotes]){
    this.envelopeName = envelopeName;
    this.initialValue=initialValue;
    this.envelopeType=envelopeType;
    this.additionalNotes=additionalNotes;
  }
}
