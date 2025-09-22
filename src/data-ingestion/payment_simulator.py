#!/usr/bin/env python3
"""
FinTech Bank Payment Data Simulator
Generates realistic UK Faster Payments and SEPA transactions
"""

import json
import random
import uuid
from datetime import datetime, timedelta
from decimal import Decimal
import boto3
import time

class PaymentSimulator:
    def __init__(self, kinesis_stream_name='fintech-bank-medallion-payments'):
        self.kinesis_client = boto3.client('kinesis')
        self.stream_name = kinesis_stream_name
        
        # UK bank sort codes
        self.uk_sort_codes = [
            '20-00-00', '40-00-00', '60-00-00', '80-00-00'
        ]
        
        # SEPA country codes
        self.sepa_countries = ['DE', 'FR', 'ES', 'IT', 'NL', 'BE']
        
        # Sample merchant names
        self.merchants = [
            'Amazon UK', 'Tesco', 'Sainsburys', 'ASDA', 'Marks & Spencer',
            'John Lewis', 'Waitrose', 'Costa Coffee', 'Starbucks', 'McDonald\'s'
        ]
        
        # Sample customer names
        self.customer_names = [
            'John Smith', 'Emma Johnson', 'Michael Brown', 'Sarah Davis',
            'James Wilson', 'Emily Taylor', 'David Anderson', 'Sophie Thomas'
        ]
    
    def generate_account_number(self):
        """Generate realistic UK account number"""
        return str(random.randint(10000000, 99999999))
    
    def generate_iban(self):
        """Generate sample IBAN"""
        country = random.choice(self.sepa_countries)
        bank_code = str(random.randint(1000, 9999))
        account = str(random.randint(100000000000, 999999999999))
        return f"{country}{random.randint(10, 99)}{bank_code}{account}"
    
    def generate_faster_payment(self):
        """Generate UK Faster Payment transaction"""
        return {
            'transaction_id': str(uuid.uuid4()),
            'payment_type': 'FASTER_PAYMENT',
            'timestamp': datetime.utcnow().isoformat(),
            'amount': float(Decimal(random.uniform(1.0, 5000.0)).quantize(Decimal('0.01'))),
            'currency': 'GBP',
            'sender': {
                'account_number': self.generate_account_number(),
                'sort_code': random.choice(self.uk_sort_codes),
                'name': random.choice(self.customer_names)
            },
            'receiver': {
                'account_number': self.generate_account_number(),
                'sort_code': random.choice(self.uk_sort_codes),
                'name': random.choice(self.merchants)
            },
            'reference': f"Payment to {random.choice(self.merchants)}",
            'status': random.choices(['COMPLETED', 'PENDING', 'FAILED'], 
                                   weights=[90, 8, 2])[0]
        }
    
    def generate_sepa_payment(self):
        """Generate SEPA Instant Credit Transfer"""
        sender_country = random.choice(self.sepa_countries)
        receiver_country = random.choice(self.sepa_countries)
        
        return {
            'transaction_id': str(uuid.uuid4()),
            'payment_type': 'SEPA_INSTANT',
            'timestamp': datetime.utcnow().isoformat(),
            'amount': float(Decimal(random.uniform(1.0, 15000.0)).quantize(Decimal('0.01'))),
            'currency': 'EUR',
            'sender': {
                'iban': self.generate_iban(),
                'name': random.choice(self.customer_names),
                'country': sender_country
            },
            'receiver': {
                'iban': self.generate_iban(),
                'name': random.choice(self.merchants),
                'country': receiver_country
            },
            'reference': f"SEPA payment - {random.choice(self.merchants)}",
            'status': random.choices(['COMPLETED', 'PENDING', 'FAILED'], 
                                   weights=[85, 12, 3])[0]
        }
    
    def send_to_kinesis(self, payment_data):
        """Send payment data to Kinesis stream"""
        try:
            response = self.kinesis_client.put_record(
                StreamName=self.stream_name,
                Data=json.dumps(payment_data),
                PartitionKey=payment_data['transaction_id']
            )
            print(f"✅ Sent {payment_data['payment_type']} - £{payment_data['amount']:.2f}")
            return response
        except Exception as e:
            print(f"❌ Error sending to Kinesis: {e}")
            return None
    
    def run_simulation(self, duration_minutes=5, transactions_per_minute=10):
        """Run payment simulation"""
        print(f"🚀 Starting FinTech Bank payment simulation")
        print(f"⏱️  Duration: {duration_minutes} minutes")
        print(f"🔄 Rate: {transactions_per_minute} transactions per minute")
        print(f"📡 Kinesis Stream: {self.stream_name}")
        print("-" * 50)
        
        end_time = datetime.utcnow() + timedelta(minutes=duration_minutes)
        transaction_count = 0
        
        while datetime.utcnow() < end_time:
            # Generate mix of payment types (70% Faster, 30% SEPA)
            if random.random() < 0.7:
                payment = self.generate_faster_payment()
            else:
                payment = self.generate_sepa_payment()
            
            # Send to Kinesis
            if self.send_to_kinesis(payment):
                transaction_count += 1
            
            # Control rate
            time.sleep(60 / transactions_per_minute)
        
        print("-" * 50)
        print(f"✅ Simulation complete!")
        print(f"📊 Generated {transaction_count} transactions")
        print(f"💰 Total volume: Mixed GBP/EUR transactions")

if __name__ == "__main__":
    print("🏦 FinTech Bank - Payment Data Simulator")
    simulator = PaymentSimulator()
    simulator.run_simulation(duration_minutes=2, transactions_per_minute=5)
