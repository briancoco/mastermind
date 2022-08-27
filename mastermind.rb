class Game 
    def initialize()
        print("Guess or Choose? (type g or c) ")
        choice = gets.chomp
        until choice == 'g' || choice == 'c' do
            print("Guess or Choose? (type g or c)")
            choice = gets.chomp
        end
        if(choice=='g')
            human = HumanPlay.new
            human.play()
        else  
            computer = ComputerPlay.new
            computer.play()
        end
        
    end
end

class HumanPlay
    attr_reader :secret
    attr_accessor :tries, :guess, :winner

    def initialize()
        @secret = rand(6).to_s + rand(6).to_s + rand(6).to_s + rand(6).to_s
        @tries = 0
        @guess = ''
        @winner = false
        puts secret
    end

    def play()
        until winner == true do
            guessCombo()
            winner?(guess)
            if tries == 12 
                puts "Sorry, out of tries."
                break
            end
        end
    end

    def guessCombo()
        print "Enter your guess(0-5)(4-digits): "
        self.guess = gets.chomp.split('')
        #could turn loop into seperate method in module
        until valid?(guess) do
            print "invalid guess, try again: "
            self.guess = gets.chomp.split('')
        end
        self.tries += 1
    end

    def valid?(array) 
        if array.length != 4
            return false
        end
        array.all? do |val|
            (val == '0' || val == '1' || val == '2' || val == '3' || val == '4' || val == '5')

        end
        
    end

    def winner?(guess) 
        if guess.join == secret
            puts "Correct! You win!"
            self.winner = true
        else  
            guess.each_with_index do |num, index| 
                if num == secret[index] 
                    puts "#{num} is exactly right!"
                elsif secret.include?(num)
                    puts "#{num} is only the right number"
                else  
                    puts "#{num} is wrong"
                end
            end
        end
        
    end



end

class ComputerPlay
    attr_accessor :knowledge, :prev_guess, :tries, :blacklist, :winner, :guess
    attr_reader :secret

    def initialize() 
        @secret = secret_code()
        @guess = Array.new(4)
        @tries = 0
        @knowledge = Array.new(4)
        @prev_guess = []
        @blacklist = []
        @winner = false
    end

    def play()
        until winner == true do
            if tries == 12
                puts "Sorry, out of tries"
                break
            end
            guess_logic()
            winner?(guess)
            self.tries +=1
        end
    end

    def secret_code()
        print "Enter the secret code(4 digits)(0-5): "
        secret = gets.chomp.split('')
        until valid?(secret) do
            print "invalid secret code, try again: "
            secret = gets.chomp.split('')
        end
        secret.join()
    end

    def valid?(array) 
        if array.length != 4
            return false
        end
        array.all? do |val|
            (val == '0' || val == '1' || val == '2' || val == '3' || val == '4' || val == '5')

        end
        
    end

    def change_guess(val, index)
        @guess[index] = val
    end

    def change_knowledge(val, index)
        @knowledge[index] = val
    end

    def guess_logic()
        for i in (0...3) do
            if i == 0
                knowledge.each_with_index do |feedback, index|
                    if feedback == 'right'
                        change_guess(prev_guess[index], index)
                        #p guess
                    end
                end
            elsif i == 1
                knowledge.each_with_index do |feedback, index|
                    if feedback == 'rightw'
                        guess_index = rand(4)
                        while guess[guess_index] != nil do
                            guess_index = rand(4)
                        end
                        if guess.include?(prev_guess[index])
                            val_guess = rand(6).to_s
                            while blacklist.include?(val_guess) do
                                val_guess = rand(6).to_s
                                
                            end
                            change_guess(val_guess, guess_index)
                            
                        else  
                            while guess_index == index || guess[guess_index] != nil do
                                guess_index = rand(4)
                            end

                            change_guess(prev_guess[index], guess_index)
                        end
                    
                    end
                end
            else  
                knowledge.each_with_index do |feedback, index|
                    if feedback == 'wrong' || feedback == nil
                        if tries > 0
                            blacklist.push(prev_guess[index])
                        end

                        guess_index = rand(4)
                        val_guess = rand(6).to_s 
                        while guess[guess_index] != nil || blacklist.include?(val_guess) do
                            guess_index = rand(4)
                            val_guess = rand(6).to_s
                        end
                        change_guess(val_guess, guess_index)
                    end
                end
            end
        end
        if guess.join() == prev_guess.join()
            self.guess = Array.new(4)
            guess_logic()
        end
        
    end

    def winner?(guess) 
        puts "Computer guessed #{guess.join}"
        if guess.join == secret
            puts "Correct! You win!"
            self.winner = true
        else  
            guess.each_with_index do |num, index| 
                if num == secret[index] 
                    change_knowledge('right', index)
                    puts "#{num} is exactly right!"
                elsif secret.include?(num)
                    change_knowledge('rightw', index)
                    puts "#{num} is only the right number"
                else  
                    change_knowledge('wrong', index)
                    puts "#{num} is wrong"
                end
            end
        end

        self.prev_guess = guess
        self.guess = Array.new(4)

    end

end

game = Game.new
