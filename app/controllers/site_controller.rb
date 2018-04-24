require 'ethereum'

class SiteController < ApplicationController
  def index
    @address = '0xEaA8D02F045a9d72453d2dF0070e2B5a81aAB823'
    @signature = '0x500bcc6adc7aa846f29843449245ca9353ce240bfd56fc9a0174978c883a124a6678c53997b5d2e3a92bb1ac262f17ab8de2d218c282109f8c4c299438df3a431b'
    @nonce = '0x5369676e206d6520696e21204d792061646472657373206973203078656161386430326630343561396437323435336432646630303730653262356138316161623832330a0a4e6f762e2032322c20323031372032313a35383a3436205554430a'
    @nonce_ascii = @nonce.sub(/^0x/,'').scan(/\w\w/).map{ |c| [c].pack('H*') }.join()
    @timestamp = begin
      @nonce_ascii =~ /\n\n(.*)\n/
      $1
    end

    @address_recovered = recover_address(@signature, @nonce_ascii)
  end

  private

    def recover_address(signature, nonce_ascii)
      signature = signature.sub(/^0x/,'')
      sig = [ signature ].pack('H*').bytes

      v = sig[64]
      r = sig[0,32].pack('c*').unpack('H*').first.to_i(16)
      s = sig[32,32].pack('c*').unpack('H*').first.to_i(16)

      message = hash_personal_message(nonce_ascii)
      pub = Ethereum::Secp256k1.recover_pubkey(message, [ v - Ethereum::Transaction::V_ZERO, r, s ])
      pubhash = Eth::Utils.keccak256(pub[1..-1])[-20..-1]

      Eth::Utils.format_address(pubhash.unpack('H*').first)
    end

    def hash_personal_message(message)
      prefix = "\u0019Ethereum Signed Message:\n" + message.length.to_s
      Eth::Utils.keccak256(prefix + message)
    end
end
