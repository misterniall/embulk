module QuickLoad::Plugin

  class CharsetGuess < Guess
    Plugin.register_guess('charset', self)

    def guess_buffer(config, sample_buffer)
      return {} if config["charset"]
      # ICU4J
      detector = com.ibm.icu.text.CharsetDetector.new
      detector.setText(sample_buffer.to_java_bytes)
      best_match = detector.detect
      name = best_match.getName
      if name == "ISO-8859-1"
        # ISO-8859-1 means ASCII which is a subset
        # of UTF-8 in most of cases due to lack of
        # sample data set
        name = "UTF-8"
      end
      return {"charset"=>name}
    end
  end

end
