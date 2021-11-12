/* eslint-disable no-template-curly-in-string */
module.exports = {
  Mappings: {
    HealthCheckSNSArn: {
      local: { Arn: 'arn:aws:sns:us-west-2:575159215130:databus-leo-local-Botmon-1CO2YSSBE00X9-HealthCheckSNS-14IM0IY6DKSG9' },
      dev: { Arn: 'arn:aws:sns:us-west-2:575159215130:databus-leo-dev-Botmon-1651E8HZDTS9M-HealthCheckSNS-JL1ETCGDTKTR' },
      tst: { Arn: 'arn:aws:sns:us-west-2:909208933214:data-bus-tst-Botmon-1SV2RTKJSQAW1-HealthCheckSNS-1LJJDIIIBEBWA' },
      prd: { Arn: 'arn:aws:sns:us-west-2:909208933214:data-bus-prd-Botmon-1SPGTRY7RQN7I-HealthCheckSNS-1V26Q8D5RRMIM' }
    }
  },
  Resources: {
    LoadSNSHealthCheckFailedSub: {
      Type: 'AWS::SNS::Subscription',
      Properties: {
        TopicArn: {
          'Fn::FindInMap': ['HealthCheckSNSArn', { Ref: 'Environment' }, 'Arn']
        },
        Endpoint: {
          'Fn::GetAtt': ['LoadSNSHealthCheckFailed', 'Arn']
        },
        Protocol: 'lambda'
      }
    },
    HealthCheckSNSLambdaInvokePermission: {
      Type: 'AWS::Lambda::Permission',
      Properties: {
        Action: 'lambda:InvokeFunction',
        Principal: 'sns.amazonaws.com',
        SourceArn: {
          'Fn::FindInMap': ['HealthCheckSNSArn', { Ref: 'Environment' }, 'Arn']
        },
        FunctionName: {
          'Fn::GetAtt': ['LoadSNSHealthCheckFailed', 'Arn']
        }
      }
    }
  }
}
